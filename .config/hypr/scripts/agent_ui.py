#!/usr/bin/env python3
import os
import json
import subprocess
from textual.app import App, ComposeResult
from textual.containers import Container, ScrollableContainer
from textual.widgets import Header, Footer, Input, Static, Markdown
from textual import work
import asyncio
from duckduckgo_search import DDGS
from openai import AsyncOpenAI

# API Setup
GROQ_API_KEY="YOUR_API_KEY_HERE"
client = AsyncOpenAI(api_key=api_key, base_url="https://api.groq.com/openai/v1")

# System tools available to the AI
tools = [
    {
        "type": "function",
        "function": {
            "name": "execute_system_command",
            "description": "Exécute une commande terminal bash sur le PC Linux de l'utilisateur. Utile pour régler le volume (wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ou 5%-), lancer des applications (firefox &), ou modifier des réglages système.",
            "parameters": {
                "type": "object",
                "properties": {
                    "command": {
                        "type": "string",
                        "description": "La commande bash exacte à exécuter (ex: 'firefox &' ou 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+'). Il faut toujours utiliser & pour lancer une application graphique.",
                    }
                },
                "required": ["command"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "search_web",
            "description": "Fait une recherche sur internet pour trouver des informations récentes ou l'actualité.",
            "parameters": {
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "La requête de recherche (ex: 'météo Paris' ou 'actualités Linux').",
                    }
                },
                "required": ["query"],
            },
        },
    }
]

def execute_system_command(command: str):
    try:
        subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        return "Commande envoyée avec succès."
    except Exception as e:
        return f"Erreur lors de l'exécution : {str(e)}"

def search_web(query: str):
    try:
        results = DDGS().text(query, max_results=3)
        formatted = "\\n".join([f"- {r['title']}: {r['body']}" for r in results])
        return f"Résultats de recherche pour '{query}' :\\n{formatted}"
    except Exception as e:
        return f"Erreur lors de la recherche : {str(e)}"

class ChatMessage(Static):
    def __init__(self, text, role):
        super().__init__()
        self.text = text
        self.role = role

    def compose(self) -> ComposeResult:
        if self.role == "user":
            yield Markdown(f"👤 **Toi:** {self.text}", id="msg-user")
        elif self.role == "assistant":
            yield Markdown(f"🤖 **Agent Groq:** {self.text}", id="msg-assistant")
        else:
            yield Markdown(f"⚙️ _{self.text}_", id="msg-system")

class AgentApp(App):
    CSS = """
    Screen {
        background: transparent;
    }
    #chat-container {
        height: 1fr;
        border: solid #06b6d4;
        border-title-color: #06b6d4;
        border-title-align: center;
        background: rgba(15, 15, 20, 0.85);
        padding: 1 2;
    }
    #input {
        dock: bottom;
        margin: 1;
        border: round #8b5cf6;
        background: rgba(39, 39, 42, 0.9);
    }
    #msg-user {
        background: rgba(6, 182, 212, 0.15);
        padding: 1;
        margin-bottom: 1;
        border-left: thick #06b6d4;
    }
    #msg-assistant {
        background: rgba(139, 92, 246, 0.15);
        padding: 1;
        margin-bottom: 1;
        border-left: thick #8b5cf6;
    }
    #msg-system {
        color: #a1a1aa;
        margin-bottom: 1;
        padding-left: 2;
    }
    """

    def __init__(self):
        super().__init__()
        base_prompt = "Tu es un Assistant IA Système avancé, intégré directement au cœur d'un PC Arch Linux utilisant Hyprland. Ton rôle est d'agir comme un ingénieur système expert et un assistant personnel ultra-compétent.\\n\\nCAPACITÉS :\\n- Tu disposes d'outils pour interagir avec le système d'exploitation de l'utilisateur (lancer des applications, ajuster le volume, modifier la configuration).\\n- Pour lancer des applications graphiques (Discord, Firefox, etc.), utilise toujours l'outil `execute_system_command` en ajoutant un `&` à la fin de la commande (ex: `firefox &`).\\n\\nPERSONNALITÉ ET INTELLIGENCE :\\n- Sois proactif, intelligent et extrêmement précis dans tes réponses techniques.\\n- Si l'utilisateur te pose une question complexe (code, système, architecture), fournis une explication claire, structurée et digne d'un expert.\\n- N'hésite pas à conseiller les meilleures pratiques Linux.\\n- Tu dois toujours répondre en français, de manière naturelle et professionnelle."
        
        # Charger un prompt personnalisé si l'utilisateur en a créé un
        custom_prompt_path = os.path.expanduser("~/.config/hypr/custom_prompt.txt")
        if os.path.exists(custom_prompt_path):
            try:
                with open(custom_prompt_path, "r", encoding="utf-8") as f:
                    custom_prompt = f.read().strip()
                if custom_prompt:
                    base_prompt += f"\\n\\nINSTRUCTIONS ADDITIONNELLES STRICTES DE L'UTILISATEUR :\\n{custom_prompt}"
            except Exception:
                pass

        self.messages = [
            {"role": "system", "content": base_prompt}
        ]
        self.current_model = "llama-4-scout"

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        with ScrollableContainer(id="chat-container") as self.chat:
            self.chat.border_title = "Agent IA Interactif (Groq Llama 3 Ultra-Rapide)"
            yield ChatMessage("Bonjour ! Je suis ton nouvel agent système propulsé par Groq. Je peux ouvrir des applications, régler le son, et répondre à tes questions en un éclair. Que puis-je faire pour toi ?", "assistant")
        yield Input(placeholder="Demande-moi de lancer une app ou pose une question...", id="input")
        yield Footer()

    def on_mount(self) -> None:
        self.query_one("#input", Input).focus()

    async def on_input_submitted(self, event: Input.Submitted) -> None:
        user_text = event.value
        if not user_text.strip():
            return
        
        # Clear input
        self.query_one("#input", Input).value = ""
        
        # Commande système pour changer de modèle
        if user_text.startswith("/model "):
            new_model = user_text.split(" ", 1)[1].strip()
            self.current_model = new_model
            await self.chat.mount(ChatMessage(user_text, "user"))
            self.chat.scroll_end(animate=False)
            self.append_message(f"✅ Modèle changé pour : `{self.current_model}`", "system")
            return
            
        # Clean up previous tool calls from history to prevent LLM loops
        clean_messages = []
        for m in self.messages:
            if isinstance(m, dict) and m.get("role") == "tool":
                continue
            if getattr(m, "tool_calls", None) or (isinstance(m, dict) and m.get("tool_calls")):
                continue
            clean_messages.append(m)
        self.messages = clean_messages
        
        # Display user message
        await self.chat.mount(ChatMessage(user_text, "user"))
        self.chat.scroll_end(animate=False)
        self.messages.append({"role": "user", "content": user_text})

        # Display empty message block for streaming
        bot_msg = ChatMessage("", "assistant")
        await self.chat.mount(bot_msg)
        self.chat.scroll_end(animate=False)

        # Call Groq API in a background thread
        asyncio.create_task(self.call_llm_stream(bot_msg))

    async def call_llm_stream(self, message_widget):
        try:
            response = await client.chat.completions.create(
                model=self.current_model,
                messages=self.messages,
                tools=tools,
                tool_choice="auto",
                temperature=0.7,
                top_p=0.9,
                max_tokens=2048,
                stream=False # First call is synchronous to check for tools
            )
            response_message = response.choices[0].message
            
            # Check if tool was called
            if response_message.tool_calls:
                self.messages.append(response_message)
                for tool_call in response_message.tool_calls:
                    args = json.loads(tool_call.function.arguments)
                    
                    if tool_call.function.name == "execute_system_command":
                        cmd = args.get("command")
                        self.append_message(f"Exécution de l'action : `{cmd}`", "system")
                        result = execute_system_command(cmd)
                        
                    elif tool_call.function.name == "search_web":
                        query = args.get("query")
                        self.append_message(f"Recherche Web : `{query}`", "system")
                        result = search_web(query)
                        
                    # Append tool result to messages
                    self.messages.append({
                        "role": "tool",
                        "tool_call_id": tool_call.id,
                        "name": tool_call.function.name,
                        "content": result
                    })
                
                # Second call to get the final answer with streaming
                stream = await client.chat.completions.create(
                    model=self.current_model,
                    messages=self.messages,
                    temperature=0.7,
                    top_p=0.9,
                    max_tokens=2048,
                    stream=True
                )
            else:
                # If no tool called, just stream the answer
                self.messages.append({"role": "assistant", "content": ""})
                
                # We need to do a new streaming request since the first one was not streaming
                stream = await client.chat.completions.create(
                    model=self.current_model,
                    messages=self.messages[:-1], # Don't send the empty assistant message
                    temperature=0.7,
                    top_p=0.9,
                    max_tokens=2048,
                    stream=True
                )

            # Process the stream
            full_response = ""
            async for chunk in stream:
                if chunk.choices[0].delta.content is not None:
                    full_response += chunk.choices[0].delta.content
                    # Update widget text
                    message_widget.text = full_response
                    # Re-render markdown
                    message_widget.query_one(Markdown).update(f"🤖 **Agent Groq:** {full_response}")
                    self.chat.scroll_end(animate=False)
            
            # Save the final text to history
            if response_message.tool_calls:
                self.messages.append({"role": "assistant", "content": full_response})
            else:
                self.messages[-1]["content"] = full_response

        except Exception as e:
            self.append_message(f"Erreur API : {str(e)}", "system")

    def append_message(self, text, role):
        self.chat.mount(ChatMessage(text, role))
        self.chat.scroll_end(animate=False)

if __name__ == "__main__":
    app = AgentApp()
    app.run()

### Dendritic patterns


sudo nixos-rebuild switch --flake .#Locomotive \
  --target-host tarobutter@locomotive \
  --build-host localhost



sudo nixos-rebuild switch --flake .#Locomotive \
  --target-host tarobutter@locomotive \
  --sudo




refresh Locomotive --by Island









sudo nixos-rebuild switch --flake .#Locomotive \
  --target-host tarobutter@192.168.100.1 \
  --sudo \
  --option sandbox false \
  --option filter-syscalls false




  sudo nixos-rebuild switch --flake .#Locomotive \
  --build-host tarobutter@loom \
  --option sandbox false \
  --option filter-syscalls false



  



sudo nixos-rebuild switch --flake .#Loom \
  --target-host tarobutter@100.83.209.81 \
  --sudo
  --option sandbox false \
  --option filter-syscalls false





  sudo nixos-rebuild boot --flake .#Locomotive \
    --build-host tarobutter@10.0.1.10 \
    --target-host tarobutter@192.168.100.1 \
    --sudo \
    --ask-sudo-password \
    --option sandbox false \
    --option filter-syscalls false

sudo nixos-rebuild boot --flake .#Loom \
  --build-host tarobutter@10.0.1.10 \
  --target-host tarobutter@100.83.209.81
  --sudo \
  --ask-sudo-password \
  --option sandbox false \
  --option filter-syscalls false




  Arrhenius, S. (1896). XXXI. On the influence of carbonic acid in the air upon the temperature of the ground. The London, Edinburgh, and Dublin Philosophical Magazine and Journal of Science, 41(251). https://doi.org/10.1080/14786449608620846




curl -v -X POST http://ai.platatoo.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"qwen_qwen3.5-0.8b","messages":[{"role":"user","content":"say hi"}]}'






    curl -v -X POST http://ai.platatoo.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
      "model": "qwen_qwen3.5-0.8b",
      "messages": [
        {
          "role": "user",
          "content": "What is the weather like in Boston?"
        }
      ],
      "tools": [
        {
          "type": "function",
          "function": {
            "name": "get_current_weather",
            "description": "Get the current weather in a given location",
            "parameters": {
              "type": "object",
              "properties": {
                "location": {
                  "type": "string",
                  "description": "The city and state, e.g. San Francisco, CA"
                },
                "unit": {
                  "type": "string",
                  "enum": ["celsius", "fahrenheit"]
                }
              },
              "required": ["location"]
            }
          }
        }
      ],
      "tool_choice": "auto"
    }'
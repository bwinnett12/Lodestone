
### Not building this out yet
### Packages needed for building on top of requirements.txt from llama-cpp
torch
mistral
transformer
mistral_common
gguf-py



  curl http://localhost:8080/embeddings -X POST -H "Content-Type:             
  application/json" -d '{ "input": "Your text string goes here", "model":     
  "text-                                                                      
  embedding-ada-002" }'
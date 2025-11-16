# n8n-AI-kit

**n8n-AI-kit** is an open-source template that quickly sets up a local AI environment featuring n8n, Ollama, PostgreSQL (pgvector) and Cloudflared.

![n8n.io - Screenshot](assets/n8n-demo.gif)

### What’s included

✅ [**Self-hosted n8n**](https://n8n.io/) - Low-code platform with over 400
integrations and advanced AI components

✅ [**Ollama**](https://ollama.com/) - Cross-platform LLM platform to install
and run the latest local LLMs

✅ [**PostgreSQL**](https://www.postgresql.org/) -  Workhorse of the Data
Engineering world, handles large amounts of data safely - including vector extension.

✅ [**Cloudflared**](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/) -  Secure reverse proxy
to access your n8n instance from anywhere.

### What you can build

⭐️ **AI Agents** for scheduling appointments

⭐️ **Summarize Company PDFs** securely without data leaks

⭐️ **Smarter Slack Bots** for enhanced company communications and IT operations

⭐️ **Private Financial Document Analysis** at minimal cost

## Installation

### Running n8n using Docker Compose

#### For Nvidia GPU users

```bash
git clone https://github.com/barrax63/n8n-ai-kit.git
cd n8n-ai-kit
cp .env.example .env # you should update the STANDARD CONFIGURATION part inside
docker compose --profile gpu-nvidia up -d
```

> [!NOTE]
> If you have not used your Nvidia GPU with Docker before, please follow the
> [Ollama Docker instructions](https://github.com/ollama/ollama/blob/main/docs/docker.md).

#### For CPU-only Users

```bash
git clone https://github.com/barrax63/n8n-ai-kit.git
cd n8n-ai-kit
cp .env.example .env # you should update the STANDARD CONFIGURATION part inside
docker compose --profile cpu up -d
```

#### For Cloud Users (without Ollama, using external LLMs)

```bash
git clone https://github.com/barrax63/n8n-ai-kit.git
cd n8n-ai-kit
cp .env.example .env # you should update the STANDARD CONFIGURATION part inside
docker compose --profile cloud up -d
```

## ⚡️ Quick start and usage

The core of the n8n-AI-kit is a Docker Compose file, pre-configured with network and storage settings, minimizing the need for additional installations.
After completing the installation steps above, simply visit <http://localhost:5678/> in your browser.

With your n8n instance, you’ll have access to over 400 integrations and a
suite of basic and advanced AI nodes such as
[AI Agent](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.agent/),
[Text classifier](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.text-classifier/),
and [Information Extractor](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.information-extractor/)
nodes. To keep everything local, just remember to use the Ollama node for your
language model and pgvector as your vector store.

## Containers and access

The kit consits of multiple containers with restricted access.
For more information on how to access the services, please refer to the table below.

| Container     | Version     | Hostname | Port  | Network accessible?      |
|---------------|-------------|----------|-------|--------------------------|
| `n8n`         | `latest`    | n8n      | 5678  | From host                |
| `n8n-runners` | `latest`    | -/-      | -/-   | -/-                      |
| `ollama`      | `latest`    | ollama   | 11434 | From Docker network only |
| `pgvector`    | `pg16`      | postgres | 5432  | From Docker network only |
| `cloudflared` | `latest`    | -/-      | -/-   | -/-                      |

### Expose n8n through Cloudflare Tunnel (optional)

1. [Create a Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/) and add an HTTP route that points to `http://n8n:5678`.
2. Copy the generated **tunnel token** into your `.env` file as `CLOUDFLARED_TUNNEL_TOKEN`.
3. Start Cloudflared alongside your preferred n8n profile:

   ```bash
   # CPU profile
   docker compose --profile cpu --profile cloudflared up -d

   # GPU profile
   docker compose --profile gpu-nvidia --profile cloudflared up -d

   # Cloud profile (external LLM)
   docker compose --profile cloud --profile cloudflared up -d
   ```

Cloudflared connects directly to Cloudflare’s edge using the `token`, so no additional configuration files are required.

## Upgrading

### For Nvidia GPU setups

```bash
git pull
docker compose --profile gpu-nvidia --profile cloudflared up -d --pull always
```

### For CPU-only setups

```bash
git pull
docker compose --profile cpu --profile cloudflared up -d --pull always
```

### For Cloud setups

```bash
git pull
docker compose --profile cloud --profile cloudflared up -d --pull always
```

### Subsequently adding a new LLM to Ollama

```bash
# From the host
ollama list                 # see what’s installed
ollama pull llama3.1:8b     # add a new model
ollama pull gemma3:4b
ollama run llama3.1:8b      # (implicit pull if missing)
```

### Enable auto-updates

You can enable auto updates by adding one of the above commands to a crontab. Run:

```bash
crontab -u <USER> -e
```

Add this entry:

```bash
# Every Sunday at 00:00 run git pull and compose up with pull-always (for profiles cloud and cloudflared)
0 0 * * 0 cd /home/<USER>/n8n-ai-kit && /usr/bin/git pull && /usr/bin/docker compose --profile cloud --profile cloudflared up -d --pull always >> /home/<USER>/n8n-ai-kit/cron.log 2>&1
```

## 👓 Recommended reading

n8n is full of useful content for getting started quickly with its AI concepts
and nodes. If you run into an issue, go to [support](#support).

- [AI agents for developers: from theory to practice with n8n](https://blog.n8n.io/ai-agents/)
- [Tutorial: Build an AI workflow in n8n](https://docs.n8n.io/advanced-ai/intro-tutorial/)
- [Langchain Concepts in n8n](https://docs.n8n.io/advanced-ai/langchain/langchain-n8n/)
- [Demonstration of key differences between agents and chains](https://docs.n8n.io/advanced-ai/examples/agent-chain-comparison/)
- [What are vector databases?](https://docs.n8n.io/advanced-ai/examples/understand-vector-databases/)

## 🎥 Video walkthrough

- [Installing and using Local AI for n8n](https://www.youtube.com/watch?v=xz_X2N-hPg0)

## Tips & tricks

### Accessing local files

The n8n-AI-kit will create a shared folder (by default,
located in the same directory) which is mounted to the n8n container and
allows n8n to access files on disk. This folder within the n8n container is
located at `/data/shared` -- this is the path you’ll need to use in nodes that
interact with the local filesystem.

**Nodes that interact with the local filesystem**

- [Read/Write Files from Disk](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.filesreadwrite/)
- [Local File Trigger](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.localfiletrigger/)
- [Execute Command](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.executecommand/)

## 📜 License

This project is licensed under the Apache License 2.0 - see the
[LICENSE](LICENSE) file for details.

## 💬 Support

Join the conversation in the [n8n Forum](https://community.n8n.io/), where you
can:

- **Share Your Work**: Show off what you’ve built with n8n and inspire others
  in the community.
- **Ask Questions**: Whether you’re just getting started or you’re a seasoned
  pro, the community and our team are ready to support with any challenges.
- **Propose Ideas**: Have an idea for a feature or improvement? Let us know!
  We’re always eager to hear what you’d like to see next.

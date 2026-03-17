# Flat Ansible (vars-driven)

- `site.yml` is the only playbook.
- `playbooks/` contains task chunks imported by `site.yml`.
- `vars.yml` is the single source of configuration.
- Folder names are for humans, not Ansible.


## Necessary preparations (on controller):

- `pip install ansible`
- `pip install passlib`
- Install psycopg2 either via pip or your distro (In my case I did `sudo pacman -S python-psycopg2`)
- `ansible-galaxy collection install community.general`
- `ansible-galaxy collection install community.postgresql`
- `sudo dnf -y install pgvector_18`

Workflow:
1. cp vault.yml.dist vault.yml
2. edit vault.yml with your info
3. run with:
```
ansible-playbook -i 'services,' site.yml \                                        [6:40:56]
  -e ansible_host=xxx.xxx.xxx.xxx \
  -e ansible_ssh_private_key_file=/path/to/key \
  --ask-become-pass \
  --ask-vault-pass
```

Other notes:
 - This project will break without `inject_facts_as_vars = True`. In the future, Ansible plans to remove `inject_facts_as_vars` entirely, which will necessitate significant overhaul, which I have chosen not to address now. 
 
- This project was built using the following versions:
```
ansible [core 2.20.1]
  config file = /home/james/Gits/ansible-service-deployment/ansible.cfg
  configured module search path = ['/home/james/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/james/Venvs/ansible_venv/lib/python3.14/site-packages/ansible
  ansible collection location = /home/james/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/james/Venvs/ansible_venv/bin/ansible
  python version = 3.14.2 (main, Jan  2 2026, 14:27:39) [GCC 15.2.1 20251112] (/home/james/Venvs/ansible_venv/bin/python3)
  jinja version = 3.1.6
  pyyaml version = 6.0.3 (with libyaml v0.2.5)
```

Note that I am a beginner and made this with a ton of help from ChatGPT. So don't go blindly using it assuming it was made by someone who knows that they are doing.

# Python Standards
This directory will contain `requirements.txt` that I can use to make sure I instantiate virtual environments of my choosing.

## How to Use

### Net New
1. Create a new virtual environment:

```bash
cd ~/.python_venvs # this should exist already, otherwise make it!
python3 -mvenv NameOfVirtualEnv
```

2. Source into it:

```bash
source ~/.python_venvs/NameOfVirtalEnv/bin/activate
```

3. Install packages via `pip`

```bash
cd ~/mydotfiles/coding/python/EnvName # something like this
pip install -r nameOfReq.txt # Select the one to use!
```

### Existing one
1. Source into it:

```bash
deactivate # if already in a venv
source ~/.python_venvs/NameOfVirtalEnv/bin/activate
```
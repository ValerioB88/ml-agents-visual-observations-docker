# ml-agents-visual-observations-docker
A minimal docker container for running ML-Agents with visual observations on a headless server.
This package uses a virtual display buffer (`xvfb`) which will not use any hardware accelleration! This method may be too slow for some usecases.

[ML-Agents](https://github.com/Unity-Technologies/ml-agents) is a toolkit for Unity that uses Unity's powerful game engine to train virtual agents. The installation and setup is very easy on Windows, but I found that managing to run it on Linux, on a Docker container, was challenging. 

The difficulties arises when you want to use visual observation (as opposite as vector observations). To do that, Unity needs a display buffer to write to, but on Docker this is not available. The solution is to use `xvfb`, a virtual frame buffer that enables the use of graphical application without a display.  However, not all `xvfb` versions will work. 

In my Dockerfile, I setup a _kind-of-minimalistic_ environment for running ML-Agents with visual observations in a Docker container. This will probably work with vector observations too. As a base image, I use [mmrl/dl-pytorch]( https://github.com/mmrl/dl), but anything with python+pip should be ok.

## Usage
The Docker image can be easily extended to run your own scene.
Here we verify that it works correctly.

Clone the repo,  and `cd` into it. Run: 
```
docker build --tag=ml-agents-visobs .
docker run -it --entrypoint /bin/bash ml-agents-visobs
```
This will allow interactive use of the container. Once inside, run:
```
Xvfb :1 -screen 0 1024x768x24 +extension GLX +render -noreset >> xsession.log 2>&1 &

python 
from mlagents_envs.environment import UnityEnvironment
from mlagents_envs.registry import default_registry
import numpy as np
env = default_registry['VisualHallway'].make()
env.reset()
behaviour_names = list(env.behavior_specs.keys())
decision_steps, terminal_steps = env.get_steps(behaviour_names[0])
print(decision_steps.obs[0])
```
 
 What does it do?  `Xvfb :1 -screen 0 1024x768x24 +extension GLX +render -noreset >> xsession.log 2>&1 &` starts the virtual buffer display on display 1. Unfortunately this can't be started from the container file, so if you run some python script you need to run this beforehand too. 
 To test if it works properly, we load the `Visual Hallway` demo. This contains visual observations. We then print the first observation in decision steps. If all runs properly, this should return a numpy float array of non-zero numbers. It works!
 
Tested on Ubuntu 19.10

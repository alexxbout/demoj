# Demoj

<div align="center"><img src="docs/logos/demoj.png" width="500"><img src="docs/logos/demotech.png" width="200"></div>

> Repository for the DemoJ project by DemoTech

# Authors

- Alexandre Boutinaud (Scrum master)
- Arthur Adam (Scrum master)
- Olivier Palvadeau (In charge of documentation)
- Yasmine Tellache
- Hadrien Moulhérat
- Cameron Salomé
- Yann Lainé Odic
- Anaelle Daumand
- Charly Piaud

Under the supervision of Olivier Ridoux who taught and helped us a lot during this project.

# Contacts

For more information related to this project please contact :

- Arthur Adam 
- [Alexandre Boutinaud](https://fr.linkedin.com/in/alexandre-boutinaud)
- [Olivier Palvadeau](https://fr.linkedin.com/in/olivier-palvadeau-6ab04a2a4)
- Hadrien Moulhérat
- [Olivier Ridoux](http://www.irisa.fr/lande/ridoux/) (Teacher at the university of Rennes)

# Summary

1. [Authors](#authors)
2. [Contacts](#contacts)
3. [Branches description](#branches)
4. [Libraries and frameworks used](#libraries--frameworks)
5. [Reports and documents](#reports-and-docs)
6. [Setup](#setup)

## Branches

Our project is divided into 3 modules and one web application.

Each module has common code available in master branch. They also have their own code in their own branch (Network, Terminal or Server)
> Common code is also shared in module's branches.

The code for the web application is available into the common.


The master branch is used for documentation and common parts such as insallation scripts and elctronics.


## Libraries & frameworks

- DFRobot INA 219
- Rpi ws281x
- Flask
- VueJS
- Ionic

## Reports and docs

We made two reports for our projects available [here](/docs/reports)

You can see our circuit diagrams [here](/docs/circuit_diagrams) 

For any other document look [here](/docs)

## Setup

1. Download and install Raspberry OS Lite on your Raspberry Pi device :
    - By using [Raspberry Pi Imager](https://www.raspberrypi.com/software/) 
    - By using your own script

    Don't forget to enable ssh and connection before installing.

2. Launch and connect to your Raspberry Pi : ```ssh username@host.local```

3. Install git : ```sudo apt install git```

4. Clone our repository :  
    - HTTPS ```git clone https://github.com/alexxbout/demoj.git```
    - SSH ```git clone git@github.com:alexxbout/demoj.git```

5. Run the [setup.sh](/setup.sh) script to install dependencies and setup environment for the module (terminal, network or sevrer) you want. 
   - ```cd demoj ; cd scripts```
   - ```./setup.sh```
   - Choose your installation

7. Disconnect, and if the network module is also set up, you may have to disconnect your personal Wifi and use the DemoJ wifi instead.

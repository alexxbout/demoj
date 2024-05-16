# Demoj

<div align="center"><img src="docs/logos/demoj.png" width="500"><img src="docs/logos/demotech.png" width="200"></div>

#### Repository for the DemoJ project by DemoTech

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

# Summary

1. [Authors](#authors) 
2. [Branches description](#branches)
3. [Libraries and frameworks used](#libraries--frameworks)
4. [Reports and documents](#reports-and-docs)
5. [Setup](#setup)

# Branches

Our project is divided into 3 modules and one web application.

Each module has common code available in master branch. They also have their own code in their own branch (Network, Terminal or Server)
> Common code is also shared in module's branches.

The code for the web application is available into the common.


The master branch is used for documentation and common parts.


# Libraries & frameworks

- DFRobot INA 219
- Rpi ws281x
- Flask
- VueJS
- Ionic

# Reports and docs

We made two reports for our projects available [here](/docs/reports)

You can see our circuit diagrams [here](/docs/circuit_diagrams) 

For any other document look [here](/docs)

## Setup

1. Download and install Raspberry OS Lite on your Raspberry Pi device :
    - By using [Raspberry Pi Imager](https://www.raspberrypi.com/software/) 
    - If you are on linux, you can use our [installation script](/install_script/raspi_os_install.sh).
    - By using your own script

    Don't forget to enable ssh and connection before installing if you don't have a screen.

2. Launch and connect to your Raspberry Pi : ```ssh username@host.local```

3. Install git : ```sudo apt install git```

4. Clone our repository :  
    - HTTPS ```git clone https://gitlab.istic.univ-rennes1.fr/arthadam/demoj.git```
    - SSH ```git clone git@gitlab.istic.univ-rennes1.fr:arthadam/demoj.git```

5. Run the [setup.sh](/setup.sh) script to install dependencies and setup environment. 
    1. ```cd demoj``` 


    2. ```source ./setup.sh```

6. You are good to run anything you want from this repo.

## TODO
- raspap.sh: Change default Raspap web interface password
- build the flask server: https://flask.palletsprojects.com/en/2.3.x/tutorial/deploy/
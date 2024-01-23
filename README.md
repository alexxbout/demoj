# Demoj

![logo](docs/logos/demoj.png)

>Repository for the DemoJ project

# Authors

- Alexandre Boutinaud (Scrum master)
- Arthur Adam (Scrum master)
- Olivier Palvadeau (In charge of documentation)
- Yasmine Tellache
- Hadrien Moulhérat
- Cameron Salomé
- Yann Lainé Odic
- Anaelle Dumand
- Charly Piaud

# Libraries & frameworks

- DFRobot INA 219
- Rpi ws281x
- Flask
- VueJS
- Ionic

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

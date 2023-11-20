verificar con que identificador se detecta el adaptador
    
    dmesg | grep tty

instalar minicom

    apt-get install minicom

configurar minicom

    minicom -s # como root
    Serial port setup
    A # y añadir el puerto donde esta el cable consola, es probable /dev/ttyUSB0

    save setup as dfl
    exit


Como alternativa:

    sudo screen /dev/ttyUSB0 9600
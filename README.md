Either install ESP-IDF v5.1.4 manually and run:
```bash
# Clone arduino-esp32
mkdir -p components
cd components/
git clone https://github.com/espressif/arduino-esp32/ arduino
cd ..

# Build project
idf.py set-target esp32c3
idf.py build
```

Or use the setup scripts for everything:
```bash
./setup-esp-idf.sh && ./install-deps.sh && ./build.sh
```


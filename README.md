Either install ESP-IDF v5.1.4 manually and run:
```bash
./install-deps.sh
idf.py set-target esp32c3
idf.py build
```

Or use the setup scripts for everything:
```bash
./setup-esp-idf.sh && ./install-deps.sh && ./build.sh
```


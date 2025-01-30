# PS2 Memory Card Manager for Termux  

This script (`mymc.sh`) automates the setup of `mymcplusplus` within Termux and provides an interactive menu to manage PlayStation 2 memory card (`.ps2`) files.  

## Features  
- Import save files into a `.ps2` memory card  
- Export save files from a `.ps2` memory card  
- View save file contents in the memory card  
- Delete save files from the memory card  

---

## Prerequisites  

Ensure **Termux** is installed on your Android device. You can download Termux from [F-Droid](https://f-droid.org/en/packages/com.termux/).  

---

## Setup Instructions  

1. Open **Termux**  
2. Copy and paste the provided script into Termux  
3. Press **Enter** to execute the script  
4. Once the setup completes, run the script with:  

   ```
   ./mymc.sh
   ```

---

## How to Use  

When you run `mymc.sh`, you will see a menu with the following options:  

1️⃣ **Import a save file** – Adds a save file to the `.ps2` memory card  
2️⃣ **Export a save file** – Extracts a save file from the `.ps2` memory card *(The extracted save will be in the same directory as the memory card)*  
3️⃣ **View save files** – Lists all save files on the memory card  
4️⃣ **Delete a save file** – Removes a specific save file from the memory card  
5️⃣ **Exit** – Closes the script  

### ⚠️ Important Note 

Before exporting or deleting a save file (option 2 or 4) use **option 3 (View Save Files)** to find the save file name. *e.g. BASLUS-20312FF090600*

---

## Running the Script Again  

After installation, you can run the script anytime with:  

```
./mymc.sh
```

---

## Notes  

- If the script fails, rerun the setup by copying and pasting the script into Termux again.
- I have only tested this with standard 8mb `.ps2` memory card files.

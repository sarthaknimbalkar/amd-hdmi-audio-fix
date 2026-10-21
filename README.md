# AMD HDMI Audio Fix

Repair the fault when a monitor shows video through HDMI but Windows shows no HDMI audio output.

## 1. Symptoms

Make sure that the computer has all of these symptoms before you start:

1. The monitor shows video through the HDMI cable.
2. Windows does not show an audio output for the monitor in the sound settings.
3. Device Manager shows "AMD High Definition Audio Device" with no error.

## 2. Procedure

### 2.1 Preparation

1. Connect the monitor to the HDMI port of the computer.
2. Make sure that the monitor shows video.

### 2.2 Replace the Audio Driver

CAUTION: Do not use a script to force the driver on the hardware ID `HDAUDIO\FUNC_01`. This hardware ID applies to all audio devices in the computer. The script can replace the drivers of all audio devices.

1. Push and hold the Windows key, then push X.
2. Select **Device Manager**.
3. Expand **Sound, video and game controllers**.
4. Right-click **AMD High Definition Audio Device**.
5. Select **Update driver**.
6. Select **Browse my computer for drivers**.
7. Select **Let me pick from a list of available drivers on my computer**.
8. Select **High Definition Audio Device**. The provider of this driver is Microsoft.
9. Select **Next**.
10. If Windows shows a warning, select **Yes**.
11. Select **Close**.

### 2.3 Set the Audio Output

1. Disconnect the HDMI cable.
2. Connect the HDMI cable again.
3. Open **Settings > System > Sound**.
4. In **Output**, select **Digital Audio (HDMI) (High Definition Audio Device)**.
5. Play an audio file.
6. Make sure that the monitor supplies audio.

NOTE: If you hear no audio, make sure that the monitor volume is not at zero. Make sure that the monitor audio is not muted.

## 3. Test

1. Open PowerShell as administrator.
2. Go to the folder of this repository.
3. Type this command and push Enter:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\check-hdmi-audio.ps1
   ```

4. Make sure that the output shows these items:
   - `basicAudio=True` for the HDMI monitor.
   - An audio endpoint with the name `Digital Audio (HDMI)`.

The script only reads data. It does not change the computer.

NOTE: If `basicAudio=False`, the monitor does not send audio data through HDMI. This procedure does not repair that fault.

## 4. Return to the Initial Condition

1. Do steps 1 to 7 of Section 2.2.
2. Select **AMD High Definition Audio Device**.
3. Select **Next**.
4. Select **Close**.

## 5. Limits

- An AMD driver update can install the AMD audio driver again. If the HDMI audio output is not available after an update, do the procedure in Section 2 again.

## 6. License

MIT License. Refer to the file `LICENSE`.

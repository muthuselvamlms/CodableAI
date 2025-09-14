# CodableAI

## Configuration

To use `CodableAI` with the OpenAI API, you need to provide your API key securely.

1. Copy the provided example configuration file:

   ```bash
   cp Example-Config.plist Config.plist
   ```

2. Open `Config.plist` and replace `<YOUR_API_KEY>` with your actual OpenAI API key:

   ```xml
   <key>OPENAI_API_KEY</key>
   <string>sk-xxxx...</string>
   ```

3. **Do not commit `Config.plist`**. It is already ignored by `.gitignore`.

This ensures your API key is not exposed in the repository and can be safely used when running or testing your project.

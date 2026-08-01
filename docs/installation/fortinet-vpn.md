# FortiClient VPN Installation & Configuration

## 📋 Overview

FortiClient VPN is required to connect to client networks and access their Active Directory domain for domain join and authentication. This guide covers installation and configuration of FortiClient VPN software.

**VPN Purpose**: Connect to client network to join Active Directory domain and access client resources  
**Software**: FortiClient VPN (by Fortinet)  
**Required For**: Domain join, accessing client servers, databases, and network resources

---

## 📥 Download FortiClient VPN

### Official Download Link
- **Fortinet Official Website**: [https://www.fortinet.com/support/product-downloads](https://www.fortinet.com/support/product-downloads)
- **Direct FortiClient Download**: [https://www.fortinet.com/products/endpoint-security/forticlient](https://www.fortinet.com/products/endpoint-security/forticlient)

### Version Selection
1. Navigate to the FortiClient download page
2. Select **FortiClient VPN** (free version for VPN-only functionality)
   - Or **FortiClient** (full version with endpoint protection, if required by client)
3. Choose **Windows** as the platform
4. Download the latest stable version for Windows 11

### Alternative: Microsoft Store
- FortiClient VPN is also available in the Microsoft Store (search "FortiClient VPN")
- May have delayed updates compared to direct download

---

## 💾 Installation

### Prerequisites
- Windows 11 with administrator rights
- Internet connection
- VPN connection details from client (server address, port, credentials)

### Installation Steps

1. **Run the Installer**
   - Locate the downloaded file (e.g., `FortiClientVPN_7.x.x_x64.exe`)
   - Right-click → **Run as administrator**
   - Click **Yes** on User Account Control prompt

2. **License Agreement**
   - Read and accept the End User License Agreement
   - Click **Next**

3. **Installation Type**
   - Select installation type:
     - **Complete**: Installs all features (recommended for first-time setup)
     - **Custom**: Choose specific components (VPN only if you don't need endpoint security)
   - Click **Next**

4. **Installation Location**
   - Default location: `C:\Program Files\Fortinet\FortiClient`
   - Change if needed or keep default
   - Click **Install**

5. **Complete Installation**
   - Wait for installation to complete (typically 2-3 minutes)
   - Click **Finish**
   - Restart computer if prompted (usually not required)

6. **Post-Installation**
   - FortiClient icon should appear in system tray
   - Launch FortiClient from Start Menu or system tray

---

## ⚙️ Configuration

### Initial Setup

1. **Launch FortiClient**
   - Click the FortiClient icon in the system tray
   - Or: Start Menu → FortiClient

2. **Navigate to VPN Settings**
   - In FortiClient main window, select **VPN** tab (or **Remote Access**)
   - Select **SSL-VPN** or **IPsec VPN** (depends on client configuration, SSL-VPN is most common)

### Configure VPN Connection

1. **Add New Connection**
   - Click **Configure VPN**
   - Click **Add** or **+** button to create new connection

2. **Connection Details** (obtain from client IT department)
   - **Connection Name**: Use value from `.env` file (`VPN_NAME`)
     - Example: "Client VPN" or specific client name
   - **Remote Gateway**: VPN server address (e.g., `vpn.client.com` or IP address)
   - **Port**: Usually 443 for SSL-VPN (or as provided by client)
   - **Authentication**:
     - Select authentication method (usually **Username/Password**)
     - Enter your VPN username (may differ from AD username)
     - Option to save password (security consideration - discuss with client)
   
3. **Advanced Settings** (if required)
   - **Client Certificate**: If client requires certificate authentication
   - **Split Tunneling**: Enable if you want to access internet outside VPN
   - **Auto Connect**: Enable if you want automatic connection on startup
   - **Timeout Settings**: Adjust keepalive/timeout as needed

4. **Save Configuration**
   - Click **Save**
   - Connection should appear in VPN list

---

## 🔌 Connecting to VPN

### Manual Connection

1. **Open FortiClient**
   - Click FortiClient icon in system tray
   - Or launch from Start Menu

2. **Select Connection**
   - In VPN tab, locate your configured connection
   - Click **Connect** button

3. **Authenticate**
   - Enter username and password (if not saved)
   - Complete any two-factor authentication if required (e.g., SMS code, authenticator app)
   - Click **OK** or **Connect**

4. **Verify Connection**
   - Status should change to **Connected**
   - VPN icon in system tray should indicate active connection (usually shows green indicator)
   - Connection time and IP address will be displayed

### Connection Verification

1. **Check Network Connectivity**
   - Open Command Prompt: `Win + R` → `cmd`
   - Test connectivity to client resources:
     ```cmd
     ping domain-controller.client.local
     ping client-server.client.local
     ```
   - Should receive replies if VPN is working correctly

2. **Verify IP Assignment**
   - In FortiClient, check assigned IP address
   - Should be within client's network range

### Disconnecting

1. **Manual Disconnect**
   - Open FortiClient
   - Click **Disconnect** button on active connection
   - Or: Right-click system tray icon → Disconnect

2. **Auto-Disconnect**
   - May disconnect automatically on sleep/hibernate (check settings)
   - Configure reconnection behavior in settings if needed

---

## 🔒 Security Best Practices

### Password Management
- **Do NOT save VPN passwords** if client policy prohibits it
- Use a secure password manager for VPN credentials
- Change VPN password according to client policy (typically every 90 days)

### Two-Factor Authentication
- Enable 2FA/MFA if client requires it
- Keep authentication app (e.g., Microsoft Authenticator, Google Authenticator) installed
- Have backup codes stored securely

### Certificate Management
- If using client certificates, store securely
- Back up certificates before system wipe
- Note certificate expiration dates
- Install client-provided certificates in correct Windows certificate store

### Split Tunneling Considerations
- **Disabled** (all traffic through VPN): More secure, client can monitor all traffic
- **Enabled** (only client traffic through VPN): Better performance for general internet use
- Follow client's policy on split tunneling

---

## 🔧 Troubleshooting

### Cannot Connect to VPN

**Issue**: "Connection failed" or "Unable to establish VPN connection"

**Solutions**:
1. Verify internet connection is active
2. Check VPN server address is correct
3. Ensure firewall/antivirus isn't blocking FortiClient
4. Verify credentials are correct and account is not locked
5. Check if VPN service is running on client's side (contact client IT)
6. Try different network (e.g., mobile hotspot vs. home WiFi)

### VPN Connects but Cannot Access Resources

**Issue**: VPN shows connected but cannot ping domain controllers or servers

**Solutions**:
1. Check DNS settings in VPN connection
2. Verify split tunneling configuration
3. Ensure correct IP range is routed through VPN
4. Check if specific ports are blocked by Windows Firewall
5. Verify you have necessary permissions on client network

### Certificate Errors

**Issue**: "Certificate verification failed" or similar errors

**Solutions**:
1. Install client-provided root CA certificate
2. Verify certificate is not expired
3. Check system date/time is correct
4. Import certificate to correct store (usually "Trusted Root Certification Authorities")

### FortiClient Won't Start or Crashes

**Issue**: Application crashes on launch or won't start

**Solutions**:
1. Restart computer
2. Reinstall FortiClient (uninstall first, then clean install)
3. Check Windows Event Viewer for error details
4. Ensure Windows 11 is updated
5. Verify no conflicting VPN software is installed

### Two-Factor Authentication Issues

**Issue**: 2FA codes not working or not received

**Solutions**:
1. Verify system time is synchronized (critical for TOTP codes)
   ```powershell
   w32tm /resync
   ```
2. Check authenticator app is synced
3. Use backup codes if available
4. Contact client IT to reset 2FA

---

## 🔄 Auto-Connect Configuration

### Enable Auto-Connect on Startup

1. **FortiClient Settings**
   - Open FortiClient → Settings
   - Enable **Start FortiClient at Windows Startup**
   - Enable **Auto-Connect on Startup** (if available and permitted)

2. **Windows Task Scheduler** (Alternative method)
   - Create scheduled task to connect VPN on user login
   - Use FortiClient CLI commands if available

### Reconnect on Network Change

1. **Configure in FortiClient**
   - Settings → VPN Settings
   - Enable **Always-up VPN** or **Auto-reconnect**
   - VPN will automatically reconnect if connection drops

---

## 📋 Domain Join Requirements

Before joining the Active Directory domain (see domain join guide):

- [ ] VPN connection is established and stable
- [ ] Can ping domain controller: `ping %DOMAIN_NAME%`
- [ ] DNS is resolving domain names correctly
- [ ] Have domain admin credentials for join operation (provided by client)
- [ ] VPN will remain connected during domain join process

**Note**: Keep VPN connected during the entire domain join process and for first domain login.

---

## 📝 Configuration Checklist

After installation and configuration:

- [ ] FortiClient VPN installed successfully
- [ ] VPN connection configured with client details
- [ ] Can successfully connect to client VPN
- [ ] Network connectivity verified (can ping client resources)
- [ ] DNS resolution working for client domain
- [ ] Client certificate installed (if required)
- [ ] Two-factor authentication configured (if required)
- [ ] VPN credentials stored securely
- [ ] Auto-connect configured (if desired)
- [ ] Split tunneling configured per client policy
- [ ] Firewall rules allow FortiClient traffic

---

## 🔗 Related Documentation

- **Next Steps**: [Join Active Directory Domain](domain-join.md)
- **Prerequisites**: [Windows 11 Fresh Install](windows-11-fresh-install.md)
- **Environment Setup**: See `.env` file for VPN_NAME and client details

---

## 📚 Additional Resources

- [FortiClient VPN Documentation](https://docs.fortinet.com/product/forticlient)
- [FortiClient VPN User Guide](https://docs.fortinet.com/document/forticlient/7.0.0/windows-release-notes)
- [Fortinet Support Portal](https://support.fortinet.com)
- [FortiClient Community Forums](https://community.fortinet.com)

---

## 📅 VPN Information

**Client**: [From `.env` - CLIENT_NAME]  
**VPN Name**: [From `.env` - VPN_NAME]  
**VPN Server**: [Contact client IT]  
**Authentication**: [Username/Password + 2FA]  
**Certificate Required**: [Yes/No]  
**Split Tunneling**: [Enabled/Disabled per client policy]

**Installation Date**: [To be filled]  
**FortiClient Version**: [To be noted]  
**Last Connection Test**: [Date]

---

**Created**: May 27, 2026  
**Purpose**: Connect to client network for domain join and resource access  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)

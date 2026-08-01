# OpenVPN Installation & Configuration

## 📋 Overview

OpenVPN is an open-source VPN client that may be required for certain clients who don't use FortiClient. This guide covers installation and configuration of OpenVPN Connect for Windows.

**Purpose**: Connect to client networks using OpenVPN protocol  
**Use Case**: Alternative VPN solution for clients not using FortiClient  
**Software**: OpenVPN Connect (official client)

---

## 📥 Download OpenVPN Connect

### Official Download

**OpenVPN Official Website**: [https://openvpn.net/client/](https://openvpn.net/client/)

1. **Visit OpenVPN Downloads Page**
   - Go to: [https://openvpn.net/client-connect-vpn-for-windows/](https://openvpn.net/client-connect-vpn-for-windows/)

2. **Download OpenVPN Connect**
   - Click **Download OpenVPN Connect v3** (latest version)
   - Or download from Microsoft Store (see alternative method below)
   - File: `OpenVPN-Connect-v3-Windows.msi`

### Alternative: Microsoft Store

1. **Open Microsoft Store**
2. **Search for "OpenVPN Connect"**
3. **Install**
   - By OpenVPN Inc.
   - Click **Get** to install

---

## 💾 Installation

### Installation Steps

1. **Run the Installer**
   - Right-click downloaded `.msi` file
   - Select **Run as administrator**
   - Click **Yes** on UAC prompt

2. **Installation Wizard**
   - Click **Next**
   - Accept license agreement
   - Click **Next**
   - Choose installation location (default: `C:\Program Files\OpenVPN Connect`)
   - Click **Install**

3. **Complete Installation**
   - Wait for installation to complete (1-2 minutes)
   - Click **Finish**
   - OpenVPN Connect may launch automatically

4. **Network Adapter Installation**
   - OpenVPN installs a TAP-Windows network adapter
   - This is normal and required for VPN functionality
   - May see driver installation prompt - click **Install**

---

## ⚙️ Configuration

### Import VPN Profile

OpenVPN requires a configuration file (.ovpn) provided by your client's IT department.

1. **Obtain .ovpn Configuration File**
   - Request from client IT department
   - File typically named: `client-vpn.ovpn` or similar
   - May also include:
     - Certificate files (.crt, .pem)
     - Key files (.key)
     - Authentication files

2. **Launch OpenVPN Connect**
   - Start Menu → OpenVPN Connect
   - Or: System tray icon

3. **Import Profile**
   
   **Method 1: Drag and Drop**
   - Drag the `.ovpn` file into OpenVPN Connect window
   
   **Method 2: File Import**
   - Click **+** (plus icon) or **Import Profile**
   - Select **File**
   - Browse to `.ovpn` file location
   - Click **Open**
   
   **Method 3: URL Import** (if provided by client)
   - Click **+** → **Import from URL**
   - Enter URL provided by client
   - Click **Import**

4. **Profile Configuration**
   - Profile name: Use descriptive name (e.g., "Client VPN")
   - Review imported settings
   - Click **Add** or **Import**

### Configure Authentication

Depending on client configuration, you may need:

1. **Username/Password Authentication**
   - Enter username and password when prompted
   - Option to save credentials (check client security policy)

2. **Certificate-Based Authentication**
   - Certificates should be included in .ovpn file
   - Or import separately if provided as separate files

3. **Two-Factor Authentication**
   - Some clients require 2FA (similar to FortiClient)
   - Enter 2FA code when prompted during connection

---

## 🔌 Connecting to VPN

### Manual Connection

1. **Launch OpenVPN Connect**
   - System tray icon or Start Menu

2. **Select Profile**
   - Click on the profile you want to connect to
   - Multiple profiles can be configured for different clients

3. **Connect**
   - Click **Connect** toggle or button
   - Enter credentials if prompted
   - Enter 2FA code if required

4. **Verify Connection**
   - Status changes to **Connected**
   - IP address and connection time displayed
   - System tray icon shows connected status (typically green)

### Connection Verification

```powershell
# Check IP address (should show VPN IP)
(Invoke-WebRequest -Uri "https://ifconfig.me/ip").Content

# Test connectivity to client resources
Test-NetConnection -ComputerName client-server.domain.local

# Ping domain controller
ping domain-controller.client.local
```

### Disconnecting

1. **Open OpenVPN Connect**
2. **Click Disconnect** on active profile
3. **Verify Disconnection**
   - Status shows "Not connected"
   - System tray icon updates

---

## ⚙️ Advanced Configuration

### Auto-Connect on Startup

1. **OpenVPN Connect Settings**
   - Click **Settings** (gear icon)
   - Enable **Launch on Windows startup**
   - Enable **Connect after launch** (if desired)

2. **Per-Profile Auto-Connect**
   - Select profile
   - Click profile settings (gear icon)
   - Configure auto-connect preferences

### Split Tunneling

If allowed by client policy:

1. **Profile Settings**
   - Select profile → Settings
   - Configure **Route traffic**:
     - **All traffic** through VPN (no split tunnel)
     - **Only specified networks** (split tunnel)

2. **Edit .ovpn File**
   - Some configurations require editing .ovpn file
   - Add/modify routing directives
   - Consult with client IT before modifying

### DNS Configuration

1. **DNS Settings**
   - Profile settings → DNS
   - Configure DNS servers (usually automatic from VPN server)
   - Option to use custom DNS if needed

---

## 🔒 Security Considerations

### Profile and Credential Security

- **Protect .ovpn files**: Contain sensitive connection information
- **Secure credential storage**: Use password manager if not saving in OpenVPN
- **Certificate protection**: Keep certificate files secure
- **Do NOT commit to Git**: Add .ovpn files to .gitignore

### Client Certificates

If using certificate authentication:
- Store certificates securely
- Back up certificates before system wipe
- Note certificate expiration dates
- Renew certificates before expiration

---

## 🔄 Multiple VPN Clients

You may need both FortiClient and OpenVPN for different clients:

### Managing Multiple VPN Solutions

1. **FortiClient** - For clients using Fortinet infrastructure
2. **OpenVPN** - For clients using OpenVPN infrastructure

**Switching Between VPNs**:
- Only one VPN active at a time (typically)
- Disconnect from one before connecting to another
- Each maintains separate profiles and settings

**Network Adapter Management**:
- FortiClient uses Fortinet SSL VPN adapter
- OpenVPN uses TAP-Windows adapter
- Both can coexist without conflicts

---

## 🐛 Troubleshooting

### Cannot Connect to VPN

**Issue**: Connection fails or times out

**Solutions**:
1. Verify internet connection is active
2. Check .ovpn file is correct and complete
3. Verify credentials are correct
4. Check firewall isn't blocking OpenVPN
   - Default port: 1194 (UDP) or 443 (TCP)
   - Allow OpenVPN through Windows Firewall
5. Try different server if multiple servers available
6. Contact client IT for server status

### Authentication Fails

**Issue**: Username/password not accepted

**Solutions**:
1. Verify credentials are correct
2. Check if account is locked or expired
3. Ensure password hasn't expired
4. Try resetting password with client IT
5. Verify 2FA code is current (if using)

### TAP Adapter Issues

**Issue**: "All TAP-Windows adapters are currently in use" error

**Solutions**:
1. Disconnect other VPN connections
2. Restart OpenVPN Connect
3. Restart computer
4. Reinstall TAP-Windows adapter:
   ```powershell
   # Uninstall OpenVPN, then reinstall
   ```

### DNS Resolution Fails

**Issue**: Connected to VPN but cannot resolve client domain names

**Solutions**:
1. Check DNS settings in profile
2. Flush DNS cache:
   ```powershell
   ipconfig /flushdns
   ```
3. Check if VPN is pushing DNS servers:
   ```powershell
   ipconfig /all
   # Look for DNS servers on TAP adapter
   ```
4. Manually configure DNS in .ovpn file (consult client IT)

### Split Tunnel Not Working

**Issue**: All traffic going through VPN (or vice versa)

**Solutions**:
1. Check profile routing settings
2. Review .ovpn file route directives
3. Consult with client IT for correct routing configuration
4. May require .ovpn file modifications

---

## 📋 Configuration Checklist

- [ ] OpenVPN Connect installed
- [ ] .ovpn profile file obtained from client
- [ ] Profile imported into OpenVPN Connect
- [ ] Connection successful
- [ ] Can ping client resources
- [ ] DNS resolution working for client domains
- [ ] Credentials saved securely (if allowed)
- [ ] 2FA configured (if required)
- [ ] Auto-connect configured (if desired)
- [ ] Split tunneling configured per policy

---

## 📝 Client VPN Information Template

Track OpenVPN configurations per client:

**Client Name**: [From .env - CLIENT_NAME]  
**VPN Profile Name**: [Descriptive name]  
**VPN Server**: [server.client.com or IP]  
**Port**: [1194 UDP / 443 TCP / other]  
**Authentication**: [Username/Password / Certificate / Both]  
**2FA Required**: [Yes/No]  
**Certificate Expiration**: [Date, if applicable]  
**DNS Servers**: [Pushed from server / Manual]  
**Split Tunnel**: [Enabled/Disabled]  
**IT Contact**: [Client IT contact info]

---

## 🔗 Related Documentation

- **FortiClient VPN**: [FortiClient Installation](fortinet-vpn.md)
- **Domain Join**: [Active Directory Domain Join](../configuration/domain-join.md)
- **Environment Variables**: See `.env` file for client information

---

## 📚 Additional Resources

- [OpenVPN Connect Documentation](https://openvpn.net/vpn-server-resources/connecting-to-access-server-with-windows/)
- [OpenVPN Community](https://forums.openvpn.net/)
- [OpenVPN Configuration Reference](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/)

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: Alternative VPN client for clients using OpenVPN infrastructure

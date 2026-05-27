# Active Directory Domain Join Configuration

## 📋 Overview

This guide covers joining your Windows 11 laptop (MIRZAKHANI) to a client's Active Directory domain and logging in with domain credentials.

**Laptop**: Dell XPS 13 9310  
**Computer Name**: MIRZAKHANI  
**Domain**: [From `.env` - DOMAIN_NAME]  
**Domain User**: [From `.env` - DOMAIN_USER]

---

## ⚠️ Prerequisites

Before joining the domain, ensure:

- [ ] **VPN Connected**: FortiClient VPN is connected to client network
  - See: [FortiClient VPN Installation](../installation/fortinet-vpn.md)
- [ ] **Network Connectivity**: Can ping domain controller
  ```cmd
  ping %DOMAIN_NAME%
  ```
- [ ] **DNS Resolution**: Client domain names resolve correctly
- [ ] **Administrator Access**: You have local administrator rights on MIRZAKHANI
- [ ] **Domain Credentials**: Client has provided domain admin credentials for join operation
- [ ] **Computer Name Set**: Laptop is named MIRZAKHANI (or as required by client)
- [ ] **Windows Updated**: All Windows updates installed
- [ ] **Backup Complete**: Important files backed up (domain join requires restart)

---

## 🔌 Domain Join Process

### Step 1: Verify VPN Connection

1. **Connect to VPN**
   - Launch FortiClient
   - Connect to client VPN
   - Verify connection is active and stable

2. **Test Network Connectivity**
   ```cmd
   ping domain-controller.client.local
   nslookup client.local
   ```
   - Should resolve and respond

### Step 2: Join the Domain

1. **Open System Properties**
   - Press `Win + Pause/Break`
   - Or: Right-click **This PC** → **Properties** → **Advanced system settings**
   - Or: Settings → System → About → **Advanced system settings**

2. **Access Computer Name Settings**
   - In System Properties, click **Computer Name** tab
   - Click **Change** button

3. **Configure Domain Membership**
   - Under "Member of":
     - Select **Domain** (not Workgroup)
     - Enter domain name from `.env` file (e.g., `client.local` or `CLIENT`)
   - Click **OK**

4. **Authenticate Domain Join**
   - Enter domain administrator credentials (provided by client IT):
     - **Username**: Domain admin username (may be different from your user account)
     - **Password**: Domain admin password
   - Click **OK**

5. **Domain Join Confirmation**
   - If successful: "Welcome to the [domain name] domain" message appears
   - If failed: See troubleshooting section below
   - Click **OK**

6. **Restart Required**
   - "You must restart your computer to apply these changes"
   - Click **OK** → **Close** → **Restart Now**
   - **Keep VPN connected during restart** (if auto-connect is configured)

---

## 👤 First Domain Login

### After Restart

1. **At Login Screen**
   - Computer will restart to Windows login screen
   - You'll see domain join has completed

2. **Select Domain Login**
   - Click **Other user** (or your profile if it shows domain option)
   - Login format options:
     - `DOMAIN_NAME\DOMAIN_USER` (e.g., `CLIENT\user1729`)
     - `DOMAIN_USER@domain.local` (e.g., `user1729@client.local`)
   - Use the format preferred by the client

3. **Enter Credentials**
   - **Username**: Enter as `DOMAIN_NAME\DOMAIN_USER` or `user@domain`
   - **Password**: Your domain password
   - Press Enter or click arrow

4. **First Login Process**
   - "Preparing Windows" message
   - Profile creation (may take 5-10 minutes for first login)
   - Desktop and user folders will be created
   - Group policies will be applied

5. **Post-Login Verification**
   - Verify you're logged in with domain account
   - Open Command Prompt and run:
     ```cmd
     whoami
     ```
   - Should display: `DOMAIN_NAME\DOMAIN_USER`

---

## ✅ Post-Domain Join Configuration

### Verify Domain Membership

1. **Check Domain Join Status**
   ```powershell
   Get-ComputerInfo | Select-Object CsDomain, CsDomainRole
   ```
   - CsDomain should show your client domain
   - CsDomainRole should show "Member Workstation"

2. **Alternative Verification**
   - Win + Pause/Break → System Properties
   - Should show: "Domain: client.local" (or your domain name)

### Apply Group Policies

1. **Force Group Policy Update**
   ```cmd
   gpupdate /force
   ```
   - Ensures all domain policies are applied
   - May take several minutes

2. **Verify Policy Application**
   ```cmd
   gpresult /r
   ```
   - Shows applied group policies

### Configure Local Administrator Access

1. **Verify Your Permissions**
   - Check if your domain account has local admin rights
   - Open Command Prompt as administrator (should work without elevation prompt)

2. **Add to Local Administrators** (if needed)
   - If you need local admin rights and don't have them:
   - Contact client IT to add your account to local administrators group
   - Or add via Group Policy if you have rights

### Network Drive Mapping

1. **Map Client Network Drives**
   - May be automatic via group policy
   - Manual mapping if needed:
     ```cmd
     net use Z: \\server\share /persistent:yes
     ```

### Printer Configuration

1. **Domain Printers**
   - Domain printers may auto-install via Group Policy
   - Check: Settings → Bluetooth & devices → Printers & scanners

---

## 🔒 Security Considerations

### Password Policy
- Domain password policy will apply
- Typical requirements:
  - Change password every 60-90 days
  - Complexity requirements (uppercase, lowercase, numbers, symbols)
  - Cannot reuse recent passwords
  - Account lockout after failed attempts

### Windows Hello
- Configure Windows Hello for Business (if permitted by client policy)
- Settings → Accounts → Sign-in options
- Set up fingerprint or PIN for domain account

### BitLocker
- Client may require BitLocker encryption
- Check with IT before enabling
- Ensure recovery key is backed up to domain/Azure AD

### Screen Lock
- Configure automatic screen lock
- Group Policy may enforce this
- Recommended: 5-10 minutes of inactivity

---

## 🔧 Troubleshooting

### Domain Join Fails

**Error**: "The specified domain either does not exist or could not be contacted"

**Solutions**:
1. Verify VPN is connected
2. Check DNS settings: `ipconfig /all`
   - DNS servers should be client's domain controllers
3. Flush DNS cache: `ipconfig /flushdns`
4. Try using FQDN instead of NetBIOS name (or vice versa)
5. Ping domain controller by name and IP
6. Verify firewall isn't blocking required ports

**Error**: "Access is denied" or authentication fails

**Solutions**:
1. Verify domain admin credentials are correct
2. Ensure account is not locked or expired
3. Check account has rights to join computers to domain
4. Verify organizational unit (OU) permissions if joining to specific OU

**Error**: "Computer account already exists"

**Solutions**:
1. Contact client IT to remove old computer account
2. Or use different computer name
3. Domain admin can reset existing computer account

### Cannot Login with Domain Credentials

**Issue**: Login fails or says credentials are incorrect

**Solutions**:
1. Verify VPN is connected BEFORE login
2. Check CAPS LOCK is off
3. Verify username format (try both `DOMAIN\user` and `user@domain.local`)
4. Ensure password is correct (try on another system if available)
5. Account might be locked - contact client IT
6. If first login, ensure profile has time to create (wait 10-15 minutes)

### VPN Required for Login

**Issue**: Cannot login without VPN connection

**Solutions**:
- This is normal for domain accounts without cached credentials
- Enable VPN auto-connect on startup
- Ensure VPN credentials are saved (if permitted)
- First login establishes cached credentials for offline login
- After first successful login, should be able to login offline (with cached credentials)

### Group Policy Not Applying

**Issue**: Expected policies or software not appearing

**Solutions**:
1. Force group policy update: `gpupdate /force`
2. Reboot computer while connected to VPN
3. Check group policy results: `gpresult /r`
4. Verify computer account is in correct OU
5. Contact client IT to verify policy targeting

---

## 🔄 Leaving the Domain (When Project Ends)

When you finish work for a client:

1. **Before Leaving Domain**
   - Back up all client work to repository/cloud
   - Export any local settings or configurations
   - Document any custom software installations

2. **Leave Domain Process**
   - Connect to VPN
   - System Properties → Computer Name → Change
   - Select "Workgroup" → enter "WORKGROUP"
   - Use domain admin credentials to leave
   - Restart

3. **After Leaving Domain**
   - Login with local account
   - Domain profile data remains in `C:\Users\domain.user`
   - Can be deleted if no longer needed
   - Uninstall FortiClient VPN if no longer used

---

## 📋 Domain Join Checklist

- [ ] VPN installed and configured
- [ ] VPN connected successfully
- [ ] Can ping domain controllers
- [ ] DNS resolving domain names
- [ ] Computer name set correctly (MIRZAKHANI)
- [ ] Have domain admin credentials
- [ ] Important files backed up
- [ ] Domain join completed successfully
- [ ] Computer restarted
- [ ] First domain login successful
- [ ] `whoami` shows domain account
- [ ] Group policies applied
- [ ] Network drives mapped (if applicable)
- [ ] Required software accessible
- [ ] Can access client resources (servers, databases)

---

## 🔗 Related Documentation

- **VPN Setup**: [FortiClient VPN Installation](../installation/fortinet-vpn.md)
- **Prerequisites**: [Windows 11 Fresh Install](../installation/windows-11-fresh-install.md)
- **Environment Variables**: See `.env` file for domain and user information

---

## 📝 Domain Information Template

Fill this out for reference:

**Client Name**: [From `.env` - CLIENT_NAME]  
**VPN Name**: [From `.env` - VPN_NAME]  
**Domain Name**: [From `.env` - DOMAIN_NAME]  
**Domain User**: [From `.env` - DOMAIN_USER]  
**Full Login**: [DOMAIN_NAME\DOMAIN_USER]  
**Domain Join Date**: [To be filled]  
**IT Contact**: [Client IT contact information]  
**Help Desk**: [Client help desk number/email]

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: Join client Active Directory domain for work

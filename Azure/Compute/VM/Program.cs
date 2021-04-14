using System;
using Microsoft.Azure.Management.Compute.Fluent;
using Microsoft.Azure.Management.Compute.Fluent.Models;
using Microsoft.Azure.Management.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Azure.Management.Network.Fluent.Models;

namespace VM
{
    class Program
    {
        static void Main(string[] args)
        {
            //Resource details
            var groupName = "rg-vm-test-westeu-1";
            var vmName = "vmconsole1";
            var location = Region.EuropeWest;
            var vNetName = "vnet-vm-test-westeu-1";
            var vNetAddress = "172.16.0.0/16";
            var subnetName = "snet-vm-test-westeu-1";
            var subnetAddress = "172.16.0.0/24";
            var nicName = "nic-vm-westeu-1";
            var adminUser = "azurevmroot";
            var adminPassword = "P@$$w0rd!";
            var publicIPName = "pip-vm-test-westeu-1";
            var nsgName = "nsg-vm-test-westeu-1";

            
            //Creates management client
            var credentials = SdkContext.AzureCredentialsFactory.FromFile("./azureAuth.properties");
            var azure = Azure.Configure().WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic).Authenticate(credentials).WithDefaultSubscription();

            Console.WriteLine($"Creating RG: {groupName}");
            var resourceGroup = azure.ResourceGroups.Define(groupName)
                .WithRegion(location)
                .Create();
            Console.WriteLine($"Creating VNET: {vNetName}");
            var vnet = azure.Networks.Define(vNetName)
                .WithRegion(location)
                .WithExistingResourceGroup(groupName)
                .WithAddressSpace(vNetAddress)
                .WithSubnet(subnetName, subnetAddress)
                .Create();   
            // Optional
            Console.WriteLine($"Creating PIP: {publicIPName}");
            var pip = azure.PublicIPAddresses.Define(publicIPName)
                .WithRegion(location)
                .WithExistingResourceGroup(groupName)
                .Create();
            // Optional
            Console.WriteLine($"Creating NSG: {nsgName}");
            var nsg = azure.NetworkSecurityGroups.Define(nsgName)
                .WithRegion(location)
                .WithExistingResourceGroup(groupName)
                .Create();
            // Optional
            Console.WriteLine($"Creating sec rule: Allow RDP");
            nsg.Update()
                .DefineRule("Allow-RDP")
                    .AllowInbound()
                    .FromAnyAddress()
                    .FromAnyPort()
                    .ToAnyAddress()
                    .ToPort(3389)
                    .WithProtocol(SecurityRuleProtocol.Tcp)
                    .WithPriority(100)
                    .WithDescription("Allow-RDP")
                    .Attach()
                .Apply();                    
            Console.WriteLine($"Creating NIC: {nicName}");
            var nic = azure.NetworkInterfaces.Define(nicName)
                .WithRegion(location)
                .WithExistingResourceGroup(groupName)
                .WithExistingPrimaryNetwork(vnet)
                .WithSubnet(subnetName)
                .WithPrimaryPrivateIPAddressDynamic()
                // Optional
                .WithExistingPrimaryPublicIPAddress(pip)
                .WithExistingNetworkSecurityGroup(nsg)
                //
                .Create();
            Console.WriteLine($"Creating VM: {vmName}");
            var vm = azure.VirtualMachines.Define(vmName)
                .WithRegion(location)
                .WithExistingResourceGroup(groupName)
                .WithExistingPrimaryNetworkInterface(nic)
                .WithLatestWindowsImage("MicrosoftWindowsServer", "WindowsServer", "2012-R2-Datacenter")
                .WithAdminUsername(adminUser)
                .WithAdminPassword(adminPassword)
                .WithComputerName(vmName)
                .WithSize(VirtualMachineSizeTypes.StandardDS2V2)
                .Create();
        }
    }
}

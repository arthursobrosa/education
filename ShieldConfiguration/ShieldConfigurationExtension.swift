//
//  ShieldConfigurationExtension.swift
//  ShieldConfiguration
//
//  Created by Arthur Sobrosa on 07/10/24.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        ShieldConfiguration(
            backgroundBlurStyle: .light,
            backgroundColor: .systemBackground,
            icon: UIImage(named: "AppIcon"),
            title: ShieldConfiguration.Label(text: "Seus estudos estão lhe esperando", color: .label),
            subtitle: ShieldConfiguration.Label(text: "“Lembre-se que as pessoas podem tirar tudo de você, menos o seu conhecimento” \n                                      - Albert Einstein", color: .secondaryLabel),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Voltar para o Planno", color: .white),
            primaryButtonBackgroundColor: .black

        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration(
            backgroundBlurStyle: .light,
            backgroundColor: .systemBackground,
            icon: UIImage(named: "AppIcon"),
            title: ShieldConfiguration.Label(text: "Seus estudos estão lhe esperando", color: .label),
            subtitle: ShieldConfiguration.Label(text: "“Lembre-se que as pessoas podem tirar tudo de você, menos o seu conhecimento”\n                                      - Albert Einstein", color: .secondaryLabel),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Voltar", color: .white),
            primaryButtonBackgroundColor: .black

        )
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
}

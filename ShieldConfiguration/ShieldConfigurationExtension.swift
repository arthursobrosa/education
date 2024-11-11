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
            icon: UIImage(named: "books"),
            title: ShieldConfiguration.Label(text: String(localized: "shieldTitle"), color: .label),
            subtitle: ShieldConfiguration.Label(
                text: String(localized: "shieldSubtitle"),
                color: .secondaryLabel
            ),
            primaryButtonLabel: ShieldConfiguration.Label(text: String(localized: "back"), color: .white),
            primaryButtonBackgroundColor: .black
        )
    }

    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration(
            backgroundBlurStyle: .light,
            backgroundColor: .systemBackground,
            icon: UIImage(named: "books"),
            title: ShieldConfiguration.Label(text: String(localized: "shieldTitle"), color: .label),
            subtitle: ShieldConfiguration.Label(
                text: String(localized: "shieldSubtitle"),
                color: .secondaryLabel
            ),
            primaryButtonLabel: ShieldConfiguration.Label(text: String(localized: "back"), color: .white),
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

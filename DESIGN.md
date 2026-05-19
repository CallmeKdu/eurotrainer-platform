---
name: EuroAcademy Corporate Identity
colors:
  surface: '#faf9f6'
  surface-dim: '#dadad7'
  surface-bright: '#faf9f6'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f4f4f0'
  surface-container: '#eeeeeb'
  surface-container-high: '#e8e8e5'
  surface-container-highest: '#e3e3df'
  on-surface: '#1a1c1a'
  on-surface-variant: '#4a4731'
  inverse-surface: '#2f312f'
  inverse-on-surface: '#f1f1ee'
  outline: '#7b785f'
  outline-variant: '#ccc7aa'
  surface-tint: '#666000'
  primary: '#666000'
  on-primary: '#ffffff'
  primary-container: '#fff209'
  on-primary-container: '#736d00'
  inverse-primary: '#d6ca00'
  secondary: '#285ea5'
  on-secondary: '#ffffff'
  secondary-container: '#82b2fe'
  on-secondary-container: '#004384'
  tertiary: '#355f97'
  on-tertiary: '#ffffff'
  tertiary-container: '#e5edff'
  on-tertiary-container: '#436ca5'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#f4e700'
  primary-fixed-dim: '#d6ca00'
  on-primary-fixed: '#1e1c00'
  on-primary-fixed-variant: '#4d4800'
  secondary-fixed: '#d6e3ff'
  secondary-fixed-dim: '#a8c8ff'
  on-secondary-fixed: '#001b3d'
  on-secondary-fixed-variant: '#00468a'
  tertiary-fixed: '#d5e3ff'
  tertiary-fixed-dim: '#a6c8ff'
  on-tertiary-fixed: '#001c3b'
  on-tertiary-fixed-variant: '#18477e'
  background: '#faf9f6'
  on-background: '#1a1c1a'
  surface-variant: '#e3e3df'
typography:
  display-lg:
    fontFamily: Public Sans
    fontSize: 57px
    fontWeight: '600'
    lineHeight: 64px
    letterSpacing: -0.25px
  headline-lg:
    fontFamily: Public Sans
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: 0px
  headline-md:
    fontFamily: Public Sans
    fontSize: 28px
    fontWeight: '500'
    lineHeight: 36px
    letterSpacing: 0px
  title-lg:
    fontFamily: Public Sans
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
    letterSpacing: 0px
  body-lg:
    fontFamily: Public Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.5px
  body-md:
    fontFamily: Public Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.25px
  label-lg:
    fontFamily: Public Sans
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-sm:
    fontFamily: Public Sans
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  xxl: 48px
  gutter: 24px
  margin: 32px
  max_width: 1440px
---

## Brand & Style

The brand identity of the design system is rooted in **Modern Corporate Industrialism**, updated with a more accessible and open interface. It is designed to evoke a sense of high energy, professional momentum, and technical precision. Given the platform's focus on compliance and corporate training, the visual language utilizes a high-visibility palette to drive engagement while maintaining an atmosphere of institutional trust.

The style follows **Material 3 principles**, utilizing a purposeful application of color and surface levels to guide the learner's journey. It balances the "energetic" punch of a high-visibility primary color with the "authoritative" feel of deep corporate blues. The current iteration introduces softer geometry and highly legible typography to ensure the system feels modern, approachable, and human-centric while navigating complex regulatory information.

## Colors

The color palette is built on a foundation of high-contrast visibility and corporate authority. The primary color is a **Vibrant Electric Yellow**, used for core navigation, headers, and primary actions to establish an energetic and recognizable brand anchor. The secondary accent is a **Corporate Deep Blue**, reserved for stable UI components and interactive elements. The tertiary accent has been updated to a **Regal Navy**, used for specialized containers and deep-contrast accents to provide a sophisticated, modern finish.

The background utilizes a **Cool Slate Neutral** to provide a sophisticated, industrial foundation that emphasizes the high-energy primary yellow without adding unnecessary warmth. Neutral greys are used for borders and secondary text to maintain a strict visual hierarchy. The design system follows Material 3's "On-Color" logic, ensuring that text and icons always meet accessibility standards against their respective backgrounds.

## Typography

This design system utilizes **Public Sans** exclusively—a strong, neutral, open-source typeface designed for clarity and reading resilience. Replacing the previous utilitarian face, Public Sans provides a more contemporary and accessible feel across all enterprise touchpoints. The type scale is optimized for high readability in information-dense compliance documents.

- **Headlines:** Use semi-bold weights (600) to create strong anchors for content sections.
- **Body Text:** Set with generous line height (1.5x) to facilitate scanning and reading comprehension.
- **Labels:** Utilized for data visualization, table headers, and micro-copy, often using medium weights (500) to distinguish from standard body text.
- **Contrast:** High-contrast ratios are maintained by using deep tonal neutrals for titles and body text to ensure maximum legibility against the clean neutral backgrounds.

## Layout & Spacing

The design system employs a **12-column responsive fluid grid** with a maximum content width of 1440px to ensure usability on large enterprise monitors while remaining legible on laptops. 

The spacing rhythm is based on an **8px linear scale**. Generous whitespace is a core tenet of the system, used to decouple complex data modules and reduce cognitive load. Gutters are fixed at 24px to provide clear separation between layout columns, while page margins are set to 32px to give content "room to breathe" against the viewport edges. Vertical rhythm is strictly maintained through the 8px base unit to ensure a mathematical harmony across varied component heights.

## Elevation & Depth

Elevation in this design system is communicated through **Tonal Layers** and **Ambient Shadows**, adhering to the Material 3 elevation model. Rather than harsh black shadows, the system uses soft, diffused shadows with a neutral grey tint to maintain the professional, industrial color profile.

- **Level 0 (Surface):** The default cool neutral background.
- **Level 1 (Card/Container):** A subtle +1dp elevation using a soft shadow (Blur: 4px, Y: 2px, Opacity: 0.05).
- **Level 2 (Hover/Active):** An increased shadow (Blur: 8px, Y: 4px, Opacity: 0.08) to indicate interactivity.
- **Level 3 (Modals/Popovers):** Used for critical overlays, utilizing a background dimming overlay (scrim) to maintain focus.

Surfaces also use subtle tonal shifts; for example, a "Surface Variant" (muted slate) may be used for sidebars to distinguish navigation from the primary content canvas.

## Shapes

The shape language is **Pill-shaped (Level 3)**, providing a modern, approachable feel that significantly softens the boldness of the industrial color palette. This increased roundedness helps to distinguish modern web components from legacy software interfaces.

- **Standard Elements:** Buttons, input fields, and small chips use a 1rem (16px) corner radius.
- **Large Containers:** Content cards and dashboard modules use a 2rem (32px) radius to clearly define structural boundaries with a distinct, friendly curve.
- **Feature Elements:** Progress bars and search bars may utilize pill-shaped (fully rounded) ends to denote fluid, ongoing processes or specific global actions.

## Components

The component library translates the professional and structured nature of the design system into functional UI elements.

- **Buttons:** Primary buttons are solid Electric Yellow with dark neutral text for maximum contrast, featuring a 1rem (16px) radius. Secondary buttons use the Corporate Deep Blue in an outlined or tonal format. Tertiary buttons are text-only for low-priority actions.
- **Cards:** The central container for training modules. They feature a light neutral background, Level 1 elevation, and a 2rem (32px) border-radius. On hover, the elevation increases to Level 2.
- **Input Fields:** Outlined style with a 1px border and a 1rem (16px) radius. Labels are always visible above the field (not floating) to ensure clarity during data entry. The focus state uses a 2px Electric Yellow border.
- **Progress Indicators:** Linear progress bars use the Regal Navy or Corporate Deep Blue accent colors with fully rounded ends to provide a high-visibility, authoritative indication of completion status.
- **Chips:** Used for categorizing compliance status. These use a pill-shaped Tonal style (light blue background with dark blue text) to remain visible but secondary to the main content.
- **Lists:** High-density data lists use subtle 1px dividers in Surface Variant grey, with generous 16px vertical padding for each row to maintain readability.
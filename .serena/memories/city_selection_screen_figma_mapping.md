City Selection screen mapping (Figma node 50:2990):
- CTA uses AppButton.primary (ButtonSize.large), width: infinity, padding: vertical 16 (56px target), radius 60.
- Colors: background surface; CTA primary; disabled CTA bg #CECECE (from AppButton.disabled style); text on CTA onPrimary.
- Header: title uses textTheme.headlineSmall with bold and onSurface; body uses bodyLarge normal, onSurface; center aligned, RTL.
- City chips: height 56, radius 60; selected fill primary with onPrimary text; unselected surface with outline 20% alpha; RTL.
- Gradients: 32px top/bottom fades using surface → transparent.
- Responsiveness: horizontal padding 24 (≤600), 32 (>600); constrained footer maxWidth 600.

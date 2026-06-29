/**
 * Button — polymorphic button supporting all design-system variants.
 * @param {'primary'|'secondary'|'ghost'|'danger'|'success'} variant
 * @param {'sm'|'md'|'lg'|'xl'} size
 * @param {boolean} fullWidth
 * @param {boolean} iconOnly
 */
export default function Button({
    children,
    variant = 'primary',
    size = 'md',
    fullWidth = false,
    iconOnly = false,
    className = '',
    ...props
}) {
    const classes = [
        'btn',
        `btn--${variant}`,
        size !== 'md' && `btn--${size}`,
        fullWidth && 'btn--full',
        iconOnly && 'btn--icon',
        className,
    ].filter(Boolean).join(' ');

    return <button className={classes} {...props}>{children}</button>;
}

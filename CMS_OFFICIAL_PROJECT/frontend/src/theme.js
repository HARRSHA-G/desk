import { extendTheme } from '@mui/joy/styles';

const theme = extendTheme({
    colorSchemes: {
        dark: {
            palette: {
                primary: {
                    50: '#fbf8f2',
                    100: '#f5efe0',
                    200: '#eadbb9',
                    300: '#dec28e',
                    400: '#d4af37', // Champagne Gold
                    500: '#b5932b',
                    600: '#967822',
                    700: '#795e1a',
                    800: '#5f4917',
                    900: '#483814',
                    solidBg: '#d4af37',
                    solidHoverBg: '#b5932b',
                    plainColor: '#d4af37',
                },
                neutral: {
                    50: '#f8fafc',
                    100: '#f1f5f9', // Slate-100
                    200: '#e2e8f0', // Slate-200
                    300: '#cbd5e1', // Slate-300
                    400: '#94a3b8', // Slate-400
                    500: '#64748b', // Slate-500
                    600: '#475569', // Slate-600
                    700: '#334155', // Slate-700
                    800: '#1e293b', // Slate-800
                    900: '#0f172a', // Slate-900 (Matte Charcoal hint)
                    plainColor: '#94a3b8',
                    plainHoverColor: '#f1f5f9',
                },
                background: {
                    body: '#0a0a0a', // Deepest Matte Charcoal
                    surface: 'rgba(20, 20, 22, 0.7)', // Translucent for glassmorphism
                    level1: '#1c1c1e',
                    level2: '#2c2c2e',
                },
                text: {
                    primary: '#f8fafc', // White/Slate-50
                    secondary: '#94a3b8', // Slate-400
                    tertiary: '#64748b', // Slate-500
                },
                divider: 'rgba(255, 255, 255, 0.08)', // Subtle white transparent
                info: {
                    50: '#f0f9ff',
                    100: '#e0f2fe',
                    200: '#bae6fd',
                    300: '#7dd3fc',
                    400: '#38bdf8',
                    500: '#007acc', // VS Code Blue (Requested)
                    600: '#0284c7',
                    700: '#0369a1',
                    800: '#075985',
                    900: '#0c4a6e',
                    solidBg: '#007acc',
                    solidHoverBg: '#0284c7',
                    plainColor: '#007acc',
                },
            },
        },
        light: {
            palette: {
                primary: {
                    50: '#fbf8f2',
                    100: '#f5efe0',
                    200: '#eadbb9',
                    300: '#dec28e',
                    400: '#d4af37',
                    500: '#b5932b',
                    600: '#967822',
                    700: '#795e1a',
                    800: '#5f4917',
                    900: '#483814',
                    solidBg: '#d4af37',
                    solidHoverBg: '#b5932b',
                    plainColor: '#d4af37',
                },
                neutral: {
                    50: '#f8fafc',
                    100: '#f1f5f9',
                    200: '#e2e8f0',
                    300: '#cbd5e1',
                    400: '#94a3b8',
                    500: '#64748b',
                    600: '#475569',
                    700: '#334155',
                    800: '#1e293b',
                    900: '#0f172a',
                },
                background: {
                    body: '#ffffff',
                    surface: 'rgba(255, 255, 255, 0.8)',
                    level1: '#f4f4f5',
                    level2: '#e4e4e7',
                },
                text: {
                    primary: '#0f172a', // Slate-900
                    secondary: '#475569', // Slate-600
                    tertiary: '#94a3b8',
                },
            },
        },
    },
    fontFamily: {
        display: "'Inter', var(--joy-fontFamily-fallback)",
        body: "'Inter', var(--joy-fontFamily-fallback)",
    },
    typography: {
        h1: { letterSpacing: '-0.02em', fontWeight: 700 },
        h2: { letterSpacing: '-0.01em', fontWeight: 600 },
        h3: { letterSpacing: '-0.01em', fontWeight: 600 },
        h4: { letterSpacing: '-0.01em', fontWeight: 600 },
        body1: { letterSpacing: '0.01em' }, // Precision tracking
        body2: { letterSpacing: '0.01em' },
    },
    components: {
        JoySheet: {
            styleOverrides: {
                root: {
                    borderRadius: '16px',
                    backdropFilter: 'blur(12px)',
                    transition: 'all 0.3s cubic-bezier(0.19, 1, 0.22, 1)',
                    border: '1px solid',
                    borderColor: 'var(--joy-palette-divider)',
                },
            },
        },
        JoyCard: {
            styleOverrides: {
                root: {
                    borderRadius: '20px',
                    boxShadow: '0 4px 24px rgba(0,0,0,0.1)',
                    backdropFilter: 'blur(18px)',
                    backgroundColor: 'var(--joy-palette-background-surface)',
                    transition: 'transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.4s cubic-bezier(0.34, 1.56, 0.64, 1)',
                    border: '1px solid',
                    borderColor: 'rgba(255, 255, 255, 0.08)',
                    '&:hover': {
                        transform: 'translateY(-4px) scale(1.01)',
                        boxShadow: '0 20px 40px rgba(0,0,0,0.2)',
                        borderColor: 'var(--joy-palette-primary-400)',
                    },
                },
            },
        },
        JoyButton: {
            styleOverrides: {
                root: {
                    borderRadius: '12px',
                    minHeight: '44px', // Rule 8: Large touch targets
                    minWidth: '44px',
                    fontWeight: 600,
                    letterSpacing: '0.02em',
                    transition: 'all 0.4s cubic-bezier(0.19, 1, 0.22, 1)',
                    '&:hover': {
                        boxShadow: '0 0 15px rgba(212, 175, 55, 0.3)', // Glow
                    },
                    '&:active': {
                        transform: 'scale(0.96)',
                    },
                    '&:focus-visible': {
                        outline: '3px solid #d4af37', // Rule 3
                        outlineOffset: '2px',
                    }
                },
            },
        },
        JoyIconButton: {
            styleOverrides: {
                root: {
                    borderRadius: '12px',
                    minHeight: '44px', // Rule 8
                    minWidth: '44px',
                    transition: 'all 0.2s ease',
                    '&:active': {
                        transform: 'scale(0.92)',
                    },
                }
            }
        },
        JoySelect: {
            styleOverrides: {
                root: {
                    borderRadius: '12px',
                    minHeight: '44px', // Rule 8
                    backdropFilter: 'blur(8px)',
                    border: '1px solid',
                    borderColor: 'rgba(255,255,255,0.08)',
                }
            }
        },
        JoyInput: {
            styleOverrides: {
                root: {
                    borderRadius: '12px',
                    minHeight: '44px', // Rule 8
                    backgroundColor: 'rgba(0,0,0,0.2)',
                    border: '1px solid',
                    borderColor: 'rgba(255,255,255,0.08)',
                    '&:focus-within': {
                        borderColor: 'var(--joy-palette-primary-400)',
                        boxShadow: '0 0 0 3px rgba(212, 175, 55, 0.25)',
                    }
                }
            }
        }
    },
});

export default theme;

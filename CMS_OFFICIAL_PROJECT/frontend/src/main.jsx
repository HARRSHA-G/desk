import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { CssVarsProvider } from '@mui/joy/styles';
import CssBaseline from '@mui/joy/CssBaseline';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { Toaster } from 'react-hot-toast';
import theme from './theme';
import './index.css';
import 'remixicon/fonts/remixicon.css';
import App from './App.jsx';

const queryClient = new QueryClient();

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <QueryClientProvider client={queryClient}>
      <CssVarsProvider theme={theme} defaultMode="dark" disableTransitionOnChange>
        <CssBaseline />
        <App />
        <Toaster position="top-right" reverseOrder={false} />
      </CssVarsProvider>
    </QueryClientProvider>
  </StrictMode>,
);

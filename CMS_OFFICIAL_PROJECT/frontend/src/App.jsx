import React, { Suspense, lazy } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import Layout from './components/Layout';

// Rule 29: Lazy Loading Components for performance
const Dashboard = lazy(() => import('./pages/dashboard/Dashboard'));
const Projects = lazy(() => import('./pages/projects/Projects'));
const Attendance = lazy(() => import('./pages/attendance/Attendance'));
// const Expenses = lazy(() => import('./pages/expenses/Expenses')); // DISABLED due to missing file
const Profile = lazy(() => import('./pages/profile/Profile'));
const MultiFlatSales = lazy(() => import('./pages/sales/MultiFlatSales'));
const MultiPlotSales = lazy(() => import('./pages/sales/MultiPlotSales'));
const Customers = lazy(() => import('./pages/crm/Customers'));
const ChannelPartners = lazy(() => import('./pages/crm/ChannelPartners'));
const CRMOverview = lazy(() => import('./pages/crm/CRMOverview'));
const Payments = lazy(() => import('./pages/finance/Payments'));
const TrackFinances = lazy(() => import('./pages/finance/TrackFinances'));
// const Insights = lazy(() => import('./pages/insights/Insights')); // DISABLED due to missing file
const Directory = lazy(() => import('./pages/directory/Directory'));
const StockManagement = lazy(() => import('./pages/stock/Stock'));

const LoadingFallback = () => (
  <div style={{ display: 'flex', height: '100vh', alignItems: 'center', justifyContent: 'center' }}>
    <div className="skeleton" style={{ width: '80%', height: '80%' }}></div>
  </div>
);

function App() {
  return (
    <Router>
      <Layout>
        <Suspense fallback={<LoadingFallback />}>
          <Routes>
            <Route path="/" element={<Navigate to="/dashboard" replace />} />
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/projects" element={<Projects />} />
            <Route path="/sales/multi-flat-sales" element={<MultiFlatSales />} />
            <Route path="/sales/multi-plot-sales" element={<MultiPlotSales />} />
            {/* Legacy project-prefixed paths kept for compatibility */}
            <Route path="/projects/multi-flat-sales" element={<MultiFlatSales />} />
            <Route path="/projects/multi-plot-sales" element={<MultiPlotSales />} />
            <Route path="/crm/overview" element={<CRMOverview />} />
            <Route path="/crm/customers" element={<Customers />} />
            <Route path="/crm/channel-partners" element={<ChannelPartners />} />
            <Route path="/finance/payments" element={<Payments />} />
            <Route path="/payments" element={<Payments />} />
            <Route path="/finance/track-finances" element={<TrackFinances />} />
            <Route path="/track-finances" element={<TrackFinances />} />
            <Route path="/attendance" element={<Attendance />} />
            {/* <Route path="/expenses" element={<Expenses />} /> */}
            <Route path="/stock" element={<StockManagement />} />
            <Route path="/directory" element={<Directory />} />
            <Route path="/directory/supervisors" element={<Directory />} />
            <Route path="/directory/vendors" element={<Directory />} />
            <Route path="/profile" element={<Profile />} />
            {/* <Route path="/insights" element={<Insights />} /> */}
            <Route path="*" element={<div style={{ padding: '2rem' }}>Page Not Found</div>} />
          </Routes>
        </Suspense>
      </Layout>
    </Router>
  );
}




export default App;

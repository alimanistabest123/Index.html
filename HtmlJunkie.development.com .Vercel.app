<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Arazure Hub - Self-Hosted Script Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --secondary: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --dark: #0f172a;
            --darker: #020617;
            --sidebar: #1e293b;
            --card-bg: #1e293b;
            --text: #f8fafc;
            --text-secondary: #94a3b8;
            --border: #334155;
            --hover: #2d3748;
            --success: #22c55e;
            --admin: #8b5cf6;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: var(--dark);
            color: var(--text);
            min-height: 100vh;
        }
        
        /* Loading Screen */
        #loadingScreen {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: var(--dark);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            transition: opacity 0.5s;
        }
        
        .loading-logo {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            margin-bottom: 20px;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        .loading-text {
            font-size: 18px;
            color: var(--text-secondary);
            margin-top: 20px;
        }
        
        /* Auth Container */
        .auth-container {
            display: none;
            min-height: 100vh;
        }
        
        .auth-container.active {
            display: flex;
        }
        
        .auth-left {
            flex: 1;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            padding: 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .auth-left::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><rect width="100" height="100" fill="none"/><path d="M0,50 Q25,25 50,50 T100,50" stroke="rgba(255,255,255,0.1)" fill="none"/></svg>');
            opacity: 0.1;
        }
        
        .auth-right {
            flex: 1;
            background: var(--dark);
            padding: 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .auth-logo {
            margin-bottom: 40px;
            position: relative;
            z-index: 1;
        }
        
        .auth-logo h1 {
            font-size: 42px;
            font-weight: 800;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #ffffff, #e2e8f0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }
        
        .auth-logo p {
            font-size: 18px;
            opacity: 0.9;
            color: rgba(255, 255, 255, 0.9);
        }
        
        .auth-features {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 30px;
            margin-top: 40px;
            max-width: 500px;
            position: relative;
            z-index: 1;
        }
        
        .feature {
            text-align: left;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s;
        }
        
        .feature:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.15);
        }
        
        .feature i {
            font-size: 24px;
            margin-bottom: 15px;
            color: rgba(255, 255, 255, 0.9);
        }
        
        .feature h3 {
            font-size: 16px;
            margin-bottom: 8px;
            color: white;
        }
        
        .feature p {
            font-size: 14px;
            opacity: 0.8;
            color: rgba(255, 255, 255, 0.8);
        }
        
        .auth-form {
            max-width: 400px;
            width: 100%;
            margin: 0 auto;
        }
        
        .auth-title {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 10px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .auth-subtitle {
            color: var(--text-secondary);
            margin-bottom: 30px;
            font-size: 16px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 10px;
            color: var(--text);
            font-weight: 500;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .form-control {
            width: 100%;
            padding: 16px 20px;
            background: var(--darker);
            border: 2px solid var(--border);
            border-radius: 12px;
            color: var(--text);
            font-size: 15px;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }
        
        .password-wrapper {
            position: relative;
        }
        
        .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-secondary);
            cursor: pointer;
            padding: 5px;
        }
        
        .btn {
            padding: 16px 24px;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            font-size: 15px;
            width: 100%;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
        }
        
        .btn-secondary {
            background: var(--darker);
            color: var(--text);
            border: 2px solid var(--border);
        }
        
        .btn-secondary:hover {
            background: var(--hover);
            transform: translateY(-2px);
        }
        
        .btn-admin {
            background: linear-gradient(135deg, var(--admin), #7c3aed);
            color: white;
            border: 2px solid rgba(139, 92, 246, 0.3);
        }
        
        .btn-admin:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(139, 92, 246, 0.4);
        }
        
        .auth-footer {
            text-align: center;
            margin-top: 30px;
            color: var(--text-secondary);
            font-size: 14px;
        }
        
        .auth-footer a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }
        
        .auth-footer a:hover {
            text-decoration: underline;
        }
        
        .secret-login {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .secret-login small {
            display: block;
            color: var(--text-secondary);
            margin-bottom: 10px;
            font-size: 12px;
        }
        
        .admin-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(139, 92, 246, 0.1);
            color: var(--admin);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 10px;
            border: 1px solid rgba(139, 92, 246, 0.3);
        }
        
        .error-message {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid var(--danger);
            color: var(--danger);
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: none;
            align-items: center;
            gap: 10px;
        }
        
        .success-message {
            background: rgba(34, 197, 94, 0.1);
            border: 1px solid var(--success);
            color: var(--success);
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: none;
            align-items: center;
            gap: 10px;
        }
        
        /* Dashboard Container */
        .dashboard-container {
            display: none;
            min-height: 100vh;
        }
        
        .dashboard-container.active {
            display: flex;
        }
        
        /* Sidebar */
        .sidebar {
            width: 280px;
            background: var(--sidebar);
            border-right: 1px solid var(--border);
            min-height: 100vh;
            position: sticky;
            top: 0;
            display: flex;
            flex-direction: column;
        }
        
        .logo {
            padding: 25px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .logo-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }
        
        .logo-text h2 {
            font-size: 22px;
            font-weight: 700;
        }
        
        .logo-text p {
            font-size: 13px;
            color: var(--text-secondary);
            margin-top: 2px;
        }
        
        .user-info {
            padding: 20px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .user-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 600;
            position: relative;
        }
        
        .user-avatar.admin::after {
            content: '';
            position: absolute;
            bottom: -2px;
            right: -2px;
            width: 16px;
            height: 16px;
            background: var(--admin);
            border-radius: 50%;
            border: 2px solid var(--sidebar);
        }
        
        .user-details h4 {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .user-details p {
            font-size: 12px;
            color: var(--text-secondary);
        }
        
        .nav-section {
            padding: 15px 0;
            border-bottom: 1px solid var(--border);
        }
        
        .section-title {
            padding: 0 25px 10px 25px;
            color: var(--text-secondary);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .nav-items {
            display: flex;
            flex-direction: column;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px 25px;
            color: var(--text-secondary);
            text-decoration: none;
            transition: all 0.3s;
            border-left: 3px solid transparent;
            cursor: pointer;
            position: relative;
        }
        
        .nav-item:hover {
            background: var(--hover);
            color: var(--text);
        }
        
        .nav-item.active {
            background: rgba(99, 102, 241, 0.1);
            color: var(--primary);
            border-left-color: var(--primary);
        }
        
        .nav-item.admin-feature {
            color: var(--admin);
        }
        
        .nav-item.admin-feature.active {
            background: rgba(139, 92, 246, 0.1);
            border-left-color: var(--admin);
        }
        
        .nav-item i {
            width: 20px;
            text-align: center;
            font-size: 16px;
        }
        
        .badge {
            position: absolute;
            right: 25px;
            background: var(--primary);
            color: white;
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 10px;
            font-weight: 600;
        }
        
        .badge.admin {
            background: var(--admin);
        }
        
        .logout-btn {
            margin: auto 20px 20px 20px;
            padding: 14px;
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.2);
            color: var(--danger);
            border-radius: 10px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            justify-content: center;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .logout-btn:hover {
            background: rgba(239, 68, 68, 0.2);
            transform: translateY(-2px);
        }
        
        /* Main Content */
        .main-content {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background: var(--darker);
        }
        
        /* Top Bar */
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 25px;
            background: var(--card-bg);
            border-radius: 16px;
            margin-bottom: 30px;
            border: 1px solid var(--border);
            background: linear-gradient(135deg, rgba(30, 41, 59, 0.9), rgba(15, 23, 42, 0.9));
            backdrop-filter: blur(10px);
        }
        
        .page-title h1 {
            font-size: 32px;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .page-title p {
            color: var(--text-secondary);
            margin-top: 8px;
            font-size: 15px;
        }
        
        .user-menu {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-badge {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 18px;
            background: var(--darker);
            border-radius: 12px;
            border: 1px solid var(--border);
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .user-badge:hover {
            background: var(--hover);
            transform: translateY(-2px);
        }
        
        .user-badge.admin {
            border-color: var(--admin);
            background: rgba(139, 92, 246, 0.1);
        }
        
        .user-badge .avatar-small {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: 600;
            position: relative;
        }
        
        .user-badge.admin .avatar-small {
            background: linear-gradient(135deg, var(--admin), #7c3aed);
        }
        
        .avatar-small.admin::after {
            content: '';
            position: absolute;
            bottom: -2px;
            right: -2px;
            width: 12px;
            height: 12px;
            background: var(--admin);
            border-radius: 50%;
            border: 2px solid var(--darker);
        }
        
        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 30px;
            border: 1px solid var(--border);
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            border-color: var(--primary);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }
        
        .stat-card.admin {
            border-color: var(--admin);
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
        }
        
        .stat-card.admin::before {
            background: linear-gradient(90deg, var(--admin), #7c3aed);
        }
        
        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .stat-title {
            color: var(--text-secondary);
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            background: rgba(99, 102, 241, 0.1);
            color: var(--primary);
        }
        
        .stat-card.admin .stat-icon {
            background: rgba(139, 92, 246, 0.1);
            color: var(--admin);
        }
        
        .stat-value {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 10px;
            font-family: 'Monaco', 'Courier New', monospace;
        }
        
        .stat-change {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
            font-weight: 500;
        }
        
        .change-up { color: var(--success); }
        .change-down { color: var(--danger); }
        
        /* Main Card */
        .main-card {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 35px;
            border: 1px solid var(--border);
            margin-bottom: 30px;
        }
        
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 25px;
            border-bottom: 1px solid var(--border);
        }
        
        .card-header h2 {
            font-size: 24px;
            font-weight: 600;
        }
        
        .card-header p {
            color: var(--text-secondary);
            margin-top: 8px;
            font-size: 15px;
        }
        
        /* Admin Panel */
        .admin-panel {
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.1), rgba(124, 58, 237, 0.05));
            border: 2px solid var(--admin);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }
        
        .admin-panel::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><path d="M0,50 Q25,25 50,50 T100,50" stroke="rgba(139, 92, 246, 0.1)" fill="none"/></svg>');
            opacity: 0.3;
        }
        
        .admin-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
            position: relative;
            z-index: 1;
        }
        
        .admin-header i {
            font-size: 32px;
            color: var(--admin);
        }
        
        .admin-header h3 {
            font-size: 22px;
            color: var(--admin);
            font-weight: 700;
        }
        
        /* Notification */
        .notification {
            position: fixed;
            top: 25px;
            right: 25px;
            padding: 18px 25px;
            border-radius: 12px;
            z-index: 10000;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            display: flex;
            align-items: center;
            gap: 12px;
            max-width: 400px;
            transform: translateX(500px);
            transition: transform 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            backdrop-filter: blur(10px);
            border: 1px solid;
        }
        
        .notification.show {
            transform: translateX(0);
        }
        
        .notification.success {
            background: rgba(34, 197, 94, 0.9);
            border-color: var(--success);
            color: white;
        }
        
        .notification.error {
            background: rgba(239, 68, 68, 0.9);
            border-color: var(--danger);
            color: white;
        }
        
        .notification.info {
            background: rgba(99, 102, 241, 0.9);
            border-color: var(--primary);
            color: white;
        }
        
        .notification.admin {
            background: rgba(139, 92, 246, 0.9);
            border-color: var(--admin);
            color: white;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .auth-container {
                flex-direction: column;
            }
            
            .auth-left, .auth-right {
                padding: 40px 20px;
            }
            
            .auth-features {
                grid-template-columns: 1fr;
                max-width: 400px;
            }
            
            .dashboard-container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                min-height: auto;
                position: relative;
            }
            
            .nav-items {
                flex-direction: row;
                overflow-x: auto;
                padding: 10px;
            }
            
            .nav-item {
                white-space: nowrap;
                border-left: none;
                border-bottom: 3px solid transparent;
                padding: 10px 15px;
                min-width: 120px;
                justify-content: center;
            }
            
            .nav-item.active {
                border-bottom-color: var(--primary);
            }
            
            .nav-item.admin-feature.active {
                border-bottom-color: var(--admin);
            }
            
            .nav-section {
                padding: 10px 0;
            }
            
            .logout-btn {
                margin: 20px auto;
                max-width: 200px;
            }
        }
        
        /* Custom Scrollbar */
        ::-webkit-scrollbar {
            width: 10px;
            height: 10px;
        }
        
        ::-webkit-scrollbar-track {
            background: var(--darker);
            border-radius: 5px;
        }
        
        ::-webkit-scrollbar-thumb {
            background: var(--border);
            border-radius: 5px;
        }
        
        ::-webkit-scrollbar-thumb:hover {
            background: var(--primary);
        }
        
        /* Spinner */
        .spinner {
            width: 40px;
            height: 40px;
            border: 3px solid var(--border);
            border-top-color: var(--primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .action-card {
            background: var(--darker);
            border-radius: 12px;
            padding: 25px;
            border: 1px solid var(--border);
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
        }
        
        .action-card:hover {
            transform: translateY(-5px);
            border-color: var(--primary);
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.2);
        }
        
        .action-card i {
            font-size: 32px;
            color: var(--primary);
            margin-bottom: 15px;
        }
        
        .action-card h4 {
            font-size: 16px;
            margin-bottom: 8px;
        }
        
        .action-card p {
            color: var(--text-secondary);
            font-size: 13px;
        }
    </style>
</head>
<body>
    <!-- Loading Screen -->
    <div id="loadingScreen">
        <div class="loading-logo">
            <i class="fas fa-cube"></i>
        </div>
        <div class="spinner"></div>
        <div class="loading-text">Initializing Arazure Hub...</div>
    </div>
    
    <!-- Auth Container -->
    <div id="authContainer" class="auth-container">
        <div class="auth-left">
            <div class="auth-logo">
                <h1>Arazure Hub</h1>
                <p>Self-Hosted Script Management Platform</p>
            </div>
            
            <div class="auth-features">
                <div class="feature">
                    <i class="fas fa-server"></i>
                    <h3>Your Own Hosting</h3>
                    <p>Full control over your script providers</p>
                </div>
                <div class="feature">
                    <i class="fas fa-key"></i>
                    <h3>Key System</h3>
                    <p>Secure access control for your scripts</p>
                </div>
                <div class="feature">
                    <i class="fas fa-chart-line"></i>
                    <h3>Analytics</h3>
                    <p>Track script usage and performance</p>
                </div>
                <div class="feature">
                    <i class="fas fa-shield-alt"></i>
                    <h3>Secure & Private</h3>
                    <p>Your data stays with you</p>
                </div>
            </div>
        </div>
        
        <div class="auth-right">
            <!-- Login Form -->
            <div id="loginForm" class="auth-form">
                <h2 class="auth-title">Welcome to Arazure Hub</h2>
                <p class="auth-subtitle">Sign in to access your dashboard</p>
                
                <div id="loginError" class="error-message"></div>
                <div id="loginSuccess" class="success-message"></div>
                
                <form id="loginFormElement" onsubmit="return handleLogin(event)">
                    <div class="form-group">
                        <label for="loginEmail">
                            <i class="fas fa-envelope"></i>
                            Email Address
                        </label>
                        <input type="email" id="loginEmail" class="form-control" placeholder="you@example.com" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="loginPassword">
                            <i class="fas fa-lock"></i>
                            Password
                        </label>
                        <div class="password-wrapper">
                            <input type="password" id="loginPassword" class="form-control" placeholder="Enter your password" required>
                            <button type="button" class="toggle-password" onclick="togglePassword('loginPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    
                    <div class="form-group" style="display: flex; align-items: center; justify-content: space-between;">
                        <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; margin: 0;">
                            <input type="checkbox" id="rememberMe" style="width: auto;">
                            <span>Remember me</span>
                        </label>
                        <a href="#" onclick="showForgotPassword()" style="color: var(--primary); font-size: 14px; text-decoration: none;">
                            Forgot password?
                        </a>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-sign-in-alt"></i> Sign In
                    </button>
                </form>
                
                <div class="secret-login">
                    <small>Secret Admin Access</small>
                    <button class="btn btn-admin" onclick="useAdminCredentials()">
                        <i class="fas fa-user-shield"></i> Use Admin Account
                    </button>
                </div>
                
                <div class="auth-footer">
                    <p>Don't have an account? <a href="#" onclick="showRegister()">Create one</a></p>
                    <p style="margin-top: 10px; font-size: 12px; color: var(--text-secondary);">
                        <i class="fas fa-info-circle"></i> All data is stored locally in your browser
                    </p>
                </div>
            </div>
            
            <!-- Register Form -->
            <div id="registerForm" class="auth-form" style="display: none;">
                <h2 class="auth-title">Join Arazure Hub</h2>
                <p class="auth-subtitle">Create your free account</p>
                
                <div id="registerError" class="error-message"></div>
                <div id="registerSuccess" class="success-message"></div>
                
                <form id="registerFormElement" onsubmit="return handleRegister(event)">
                    <div class="form-group">
                        <label for="registerUsername">
                            <i class="fas fa-user"></i>
                            Username
                        </label>
                        <input type="text" id="registerUsername" class="form-control" placeholder="Choose a username" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="registerEmail">
                            <i class="fas fa-envelope"></i>
                            Email Address
                        </label>
                        <input type="email" id="registerEmail" class="form-control" placeholder="you@example.com" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="registerPassword">
                            <i class="fas fa-lock"></i>
                            Password
                        </label>
                        <div class="password-wrapper">
                            <input type="password" id="registerPassword" class="form-control" placeholder="Create a password (min. 6 characters)" required minlength="6">
                            <button type="button" class="toggle-password" onclick="togglePassword('registerPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="registerConfirmPassword">
                            <i class="fas fa-lock"></i>
                            Confirm Password
                        </label>
                        <div class="password-wrapper">
                            <input type="password" id="registerConfirmPassword" class="form-control" placeholder="Confirm your password" required>
                            <button type="button" class="toggle-password" onclick="togglePassword('registerConfirmPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label style="display: flex; align-items: flex-start; gap: 8px; cursor: pointer;">
                            <input type="checkbox" id="acceptTerms" required style="width: auto; margin-top: 3px;">
                            <span>I agree to the <a href="#" style="color: var(--primary);">Terms of Service</a> and <a href="#" style="color: var(--primary);">Privacy Policy</a></span>
                        </label>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-user-plus"></i> Create Account
                    </button>
                </form>
                
                <div class="auth-footer">
                    <p>Already have an account? <a href="#" onclick="showLogin()">Sign in</a></p>
                </div>
            </div>
            
            <!-- Forgot Password Form -->
            <div id="forgotPasswordForm" class="auth-form" style="display: none;">
                <h2 class="auth-title">Reset Password</h2>
                <p class="auth-subtitle">Enter your email to reset your password</p>
                
                <div id="forgotError" class="error-message"></div>
                <div id="forgotSuccess" class="success-message"></div>
                
                <form id="forgotFormElement" onsubmit="return handleForgotPassword(event)">
                    <div class="form-group">
                        <label for="forgotEmail">
                            <i class="fas fa-envelope"></i>
                            Email Address
                        </label>
                        <input type="email" id="forgotEmail" class="form-control" placeholder="you@example.com" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-key"></i> Reset Password
                    </button>
                </form>
                
                <div class="auth-footer">
                    <p><a href="#" onclick="showLogin()">Back to login</a></p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Dashboard Container -->
    <div id="dashboardContainer" class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fas fa-cube"></i>
                </div>
                <div class="logo-text">
                    <h2>Arazure Hub</h2>
                    <p id="userEmail">Loading...</p>
                </div>
            </div>
            
            <div class="user-info">
                <div class="user-avatar" id="userAvatar">U</div>
                <div class="user-details">
                    <h4 id="userName">Loading...</h4>
                    <p id="userRole">User</p>
                </div>
            </div>
            
            <!-- Navigation Sections -->
            <div class="nav-section">
                <div class="section-title">Dashboard</div>
                <div class="nav-items">
                    <div class="nav-item active" onclick="switchTab('overview')">
                        <i class="fas fa-home"></i>
                        <span>Overview</span>
                    </div>
                    <div class="nav-item" onclick="switchTab('analytics')">
                        <i class="fas fa-chart-line"></i>
                        <span>Analytics</span>
                    </div>
                    <div class="nav-item" onclick="switchTab('reports')">
                        <i class="fas fa-file-alt"></i>
                        <span>Reports</span>
                        <span class="badge">New</span>
                    </div>
                </div>
            </div>
            
            <div class="nav-section">
                <div class="section-title">Script Management</div>
                <div class="nav-items">
                    <div class="nav-item" onclick="switchTab('publish')">
                        <i class="fas fa-upload"></i>
                        <span>Publish Script</span>
                    </div>
                    <div class="nav-item" onclick="switchTab('scripts')">
                        <i class="fas fa-code"></i>
                        <span>My Scripts</span>
                    </div>
                    <div class="nav-item" onclick="switchTab('loadstrings')">
                        <i class="fas fa-link"></i>
                        <span>Loadstrings</span>
                    </div>
                </div>
            </div>
            
            <div class="nav-section">
                <div class="section-title">System Management</div>
                <div class="nav-items">
                    <div class="nav-item" onclick="switchTab('providers')">
                        <i class="fas fa-cube"></i>
                        <span>My Providers</span>
                    </div>
                    <div class="nav-item" onclick="switchTab('keys')">
                        <i class="fas fa-key"></i>
                        <span>Key System</span>
                        <span class="badge">Pro</span>
                    </div>
                    <div class="nav-item" onclick="switchTab('webhooks')">
                        <i class="fas fa-bell"></i>
                        <span>Webhooks</span>
                    </div>
                    <div class="nav-item" onclick="switchTab('settings')">
                        <i class="fas fa-cog"></i>
                        <span>Settings</span>
                    </div>
                </div>
            </div>
            
            <!-- Admin Section (Only shown for admin) -->
            <div class="nav-section" id="adminSection" style="display: none;">
                <div class="section-title">Admin Panel</div>
                <div class="nav-items">
                    <div class="nav-item admin-feature" onclick="switchTab('admin-users')">
                        <i class="fas fa-users"></i>
                        <span>User Management</span>
                        <span class="badge admin">Admin</span>
                    </div>
                    <div class="nav-item admin-feature" onclick="switchTab('admin-system')">
                        <i class="fas fa-server"></i>
                        <span>System Control</span>
                        <span class="badge admin">Admin</span>
                    </div>
                    <div class="nav-item admin-feature" onclick="switchTab('admin-logs')">
                        <i class="fas fa-clipboard-list"></i>
                        <span>Audit Logs</span>
                        <span class="badge admin">Admin</span>
                    </div>
                </div>
            </div>
            
            <div class="nav-section">
                <div class="section-title">Account</div>
                <div class="nav-items">
                    <div class="nav-item" onclick="switchTab('profile')">
                        <i class="fas fa-user"></i>
                        <span>My Profile</span>
                    </div>
                    <div class="nav-item" onclick="switchTab('billing')">
                        <i class="fas fa-credit-card"></i>
                        <span>Billing</span>
                    </div>
                </div>
            </div>
            
            <div class="logout-btn" onclick="handleLogout()">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Bar -->
            <div class="top-bar">
                <div class="page-title">
                    <h1 id="pageTitle">Dashboard Overview</h1>
                    <p id="pageSubtitle">Welcome back to Arazure Hub</p>
                </div>
                <div class="user-menu">
                    <div class="user-badge" onclick="switchTab('profile')" id="topUserBadge">
                        <div class="avatar-small" id="topAvatar">U</div>
                        <span id="topUsername">User</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <button class="btn btn-primary" onclick="switchTab('publish')">
                        <i class="fas fa-plus"></i> Publish Script
                    </button>
                </div>
            </div>
            
            <!-- Content Areas -->
            <div id="overview" class="content-area active">
                <!-- Admin Panel (Only shown for admin) -->
                <div class="admin-panel" id="adminWelcomePanel" style="display: none;">
                    <div class="admin-header">
                        <i class="fas fa-user-shield"></i>
                        <h3>Admin Dashboard</h3>
                    </div>
                    <p style="color: var(--text-secondary); margin-bottom: 20px; position: relative; z-index: 1;">
                        Welcome, <strong style="color: var(--admin);">Aljamantugay456</strong>. You have full administrative access to the system.
                    </p>
                    <div class="quick-actions">
                        <div class="action-card" onclick="switchTab('admin-users')">
                            <i class="fas fa-users"></i>
                            <h4>Manage Users</h4>
                            <p>View and manage all registered users</p>
                        </div>
                        <div class="action-card" onclick="switchTab('admin-system')">
                            <i class="fas fa-server"></i>
                            <h4>System Settings</h4>
                            <p>Configure system-wide settings</p>
                        </div>
                        <div class="action-card" onclick="switchTab('admin-logs')">
                            <i class="fas fa-clipboard-list"></i>
                            <h4>View Logs</h4>
                            <p>Check system and user activity logs</p>
                        </div>
                    </div>
                </div>
                
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-title">Total Scripts</div>
                            <div class="stat-icon">
                                <i class="fas fa-file-code"></i>
                            </div>
                        </div>
                        <div class="stat-value" id="totalScripts">0</div>
                        <div class="stat-change change-up">
                            <i class="fas fa-arrow-up"></i>
                            <span>0 this week</span>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-title">Active Providers</div>
                            <div class="stat-icon">
                                <i class="fas fa-cube"></i>
                            </div>
                        </div>
                        <div class="stat-value" id="activeProviders">1</div>
                        <div class="stat-change change-up">
                            <i class="fas fa-arrow-up"></i>
                            <span>Self-Hosted</span>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-title">Total Keys</div>
                            <div class="stat-icon">
                                <i class="fas fa-key"></i>
                            </div>
                        </div>
                        <div class="stat-value" id="totalKeys">0</div>
                        <div class="stat-change change-up">
                            <i class="fas fa-arrow-up"></i>
                            <span>Ready to generate</span>
                        </div>
                    </div>
                    
                    <div class="stat-card" id="adminStatCard" style="display: none;">
                        <div class="stat-header">
                            <div class="stat-title">Total Users</div>
                            <div class="stat-icon">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <div class="stat-value" id="totalUsers">1</div>
                        <div class="stat-change change-up">
                            <i class="fas fa-arrow-up"></i>
                            <span>Admin included</span>
                        </div>
                    </div>
                </div>
                
                <div class="main-card">
                    <div class="card-header">
                        <div>
                            <h2>Recent Activity</h2>
                            <p>Your recent script publications and executions</p>
                        </div>
                        <button class="btn btn-secondary" onclick="refreshDashboard()">
                            <i class="fas fa-sync-alt"></i> Refresh
                        </button>
                    </div>
                    <div id="recentActivity" style="min-height: 200px; display: flex; align-items: center; justify-content: center;">
                        <div class="spinner"></div>
                    </div>
                </div>
            </div>
            
            <!-- Other tabs content -->
            <div id="profile" class="content-area" style="display: none;">
                <div class="main-card">
                    <div class="card-header">
                        <div>
                            <h2>My Profile</h2>
                            <p>Manage your account information</p>
                        </div>
                    </div>
                    <div id="profileContent">
                        <div class="spinner"></div>
                    </div>
                </div>
            </div>
            
            <!-- Admin Tabs -->
            <div id="admin-users" class="content-area" style="display: none;">
                <div class="main-card">
                    <div class="card-header">
                        <div>
                            <h2><i class="fas fa-users" style="color: var(--admin);"></i> User Management</h2>
                            <p>Manage all registered users in the system</p>
                        </div>
                    </div>
                    <div style="padding: 30px; text-align: center; color: var(--text-secondary);">
                        <i class="fas fa-user-shield" style="font-size: 48px; color: var(--admin); margin-bottom: 20px;"></i>
                        <h3 style="margin-bottom: 15px;">Admin User Management</h3>
                        <p>You are currently logged in as the system administrator.</p>
                        <div style="background: rgba(139, 92, 246, 0.1); border-radius: 12px; padding: 20px; margin-top: 30px; text-align: left;">
                            <h4 style="color: var(--admin); margin-bottom: 15px;">Admin Account Details:</h4>
                            <p><strong>Username:</strong> Aljamantugay456</p>
                            <p><strong>Email:</strong> aljamantugay456@gmail.com</p>
                            <p><strong>Role:</strong> System Administrator</p>
                            <p><strong>Permissions:</strong> Full system access</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Notification Container -->
    <div id="notificationContainer"></div>
    
    <script>
        // ==============================
        // SECRET ADMIN CREDENTIALS
        // ==============================
        const SECRET_ADMIN_EMAIL = "aljamantugay456@gmail.com";
        const SECRET_ADMIN_PASSWORD = "Paldo";
        const SECRET_ADMIN_USERNAME = "Aljamantugay456";
        
        // ==============================
        // API Configuration
        // ==============================
        const API_BASE = window.location.origin;
        
        // ==============================
        // State Management
        // ==============================
        let currentUser = null;
        let authToken = localStorage.getItem('authToken');
        let isAdmin = false;
        
        // ==============================
        // Initialize Application
        // ==============================
        async function init() {
            // Show loading screen
            setTimeout(() => {
                document.getElementById('loadingScreen').style.opacity = '0';
                setTimeout(() => {
                    document.getElementById('loadingScreen').style.display = 'none';
                    
                    // Check if user is already logged in
                    if (authToken) {
                        checkSession();
                    } else {
                        showAuth();
                        showLogin();
                    }
                }, 500);
            }, 1500);
        }
        
        // ==============================
        // Authentication Functions
        // ==============================
        function checkSession() {
            try {
                const userData = localStorage.getItem('userData');
                if (userData) {
                    currentUser = JSON.parse(userData);
                    isAdmin = currentUser.email === SECRET_ADMIN_EMAIL;
                    showDashboard();
                    return;
                }
            } catch (error) {
                console.error('Session check failed:', error);
            }
            showAuth();
        }
        
        async function handleLogin(event) {
            event.preventDefault();
            
            const email = document.getElementById('loginEmail').value;
            const password = document.getElementById('loginPassword').value;
            const rememberMe = document.getElementById('rememberMe').checked;
            
            // Show loading
            const btn = event.target.querySelector('button[type="submit"]');
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Signing in...';
            btn.disabled = true;
            
            // Clear previous errors
            document.getElementById('loginError').style.display = 'none';
            document.getElementById('loginSuccess').style.display = 'none';
            
            try {
                // Simulate API delay
                await new Promise(resolve => setTimeout(resolve, 1000));
                
                // Check if it's the secret admin account
                if (email === SECRET_ADMIN_EMAIL && password === SECRET_ADMIN_PASSWORD) {
                    // Admin login successful
                    currentUser = {
                        id: 'admin-001',
                        username: SECRET_ADMIN_USERNAME,
                        email: SECRET_ADMIN_EMAIL,
                        role: 'admin',
                        isAdmin: true,
                        createdAt: new Date().toISOString(),
                        lastLogin: new Date().toISOString()
                    };
                    
                    isAdmin = true;
                    
                    // Save to localStorage
                    localStorage.setItem('userData', JSON.stringify(currentUser));
                    localStorage.setItem('authToken', 'admin-token-' + Date.now());
                    if (rememberMe) {
                        localStorage.setItem('rememberMe', 'true');
                        localStorage.setItem('userEmail', email);
                    }
                    
                    // Show success
                    document.getElementById('loginSuccess').innerHTML = '<i class="fas fa-check-circle"></i> Welcome back, Admin!';
                    document.getElementById('loginSuccess').style.display = 'flex';
                    
                    showNotification('Administrator access granted!', 'admin');
                    
                    setTimeout(() => {
                        showDashboard();
                    }, 1500);
                    
                } else {
                    // Regular user login
                    const users = JSON.parse(localStorage.getItem('users') || '[]');
                    const user = users.find(u => u.email === email && u.password === password);
                    
                    if (user) {
                        currentUser = user;
                        isAdmin = false;
                        
                        // Update last login
                        user.lastLogin = new Date().toISOString();
                        localStorage.setItem('users', JSON.stringify(users));
                        localStorage.setItem('userData', JSON.stringify(currentUser));
                        localStorage.setItem('authToken', 'user-token-' + Date.now());
                        
                        if (rememberMe) {
                            localStorage.setItem('rememberMe', 'true');
                            localStorage.setItem('userEmail', email);
                        }
                        
                        document.getElementById('loginSuccess').innerHTML = '<i class="fas fa-check-circle"></i> Login successful!';
                        document.getElementById('loginSuccess').style.display = 'flex';
                        
                        showNotification('Welcome back!', 'success');
                        
                        setTimeout(() => {
                            showDashboard();
                        }, 1000);
                        
                    } else {
                        document.getElementById('loginError').innerHTML = '<i class="fas fa-exclamation-circle"></i> Invalid email or password';
                        document.getElementById('loginError').style.display = 'flex';
                    }
                }
                
            } catch (error) {
                document.getElementById('loginError').innerHTML = '<i class="fas fa-exclamation-circle"></i> Login error. Please try again.';
                document.getElementById('loginError').style.display = 'flex';
            } finally {
                btn.innerHTML = originalText;
                btn.disabled = false;
            }
            
            return false;
        }
        
        async function handleRegister(event) {
            event.preventDefault();
            
            const username = document.getElementById('registerUsername').value;
            const email = document.getElementById('registerEmail').value;
            const password = document.getElementById('registerPassword').value;
            const confirmPassword = document.getElementById('registerConfirmPassword').value;
            
            // Validation
            if (password !== confirmPassword) {
                document.getElementById('registerError').innerHTML = '<i class="fas fa-exclamation-circle"></i> Passwords do not match';
                document.getElementById('registerError').style.display = 'flex';
                return false;
            }
            
            if (password.length < 6) {
                document.getElementById('registerError').innerHTML = '<i class="fas fa-exclamation-circle"></i> Password must be at least 6 characters';
                document.getElementById('registerError').style.display = 'flex';
                return false;
            }
            
            // Check if it's the secret admin email
            if (email === SECRET_ADMIN_EMAIL) {
                document.getElementById('registerError').innerHTML = '<i class="fas fa-exclamation-circle"></i> This email is reserved for system administration';
                document.getElementById('registerError').style.display = 'flex';
                return false;
            }
            
            // Show loading
            const btn = event.target.querySelector('button[type="submit"]');
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating account...';
            btn.disabled = true;
            
            // Clear previous errors
            document.getElementById('registerError').style.display = 'none';
            document.getElementById('registerSuccess').style.display = 'none';
            
            try {
                await new Promise(resolve => setTimeout(resolve, 1500));
                
                // Get existing users
                const users = JSON.parse(localStorage.getItem('users') || '[]');
                
                // Check if user already exists
                if (users.some(u => u.email === email)) {
                    document.getElementById('registerError').innerHTML = '<i class="fas fa-exclamation-circle"></i> User already exists';
                    document.getElementById('registerError').style.display = 'flex';
                    return false;
                }
                
                // Create new user
                const newUser = {
                    id: 'user-' + Date.now(),
                    username,
                    email,
                    password,
                    role: 'user',
                    isAdmin: false,
                    createdAt: new Date().toISOString(),
                    lastLogin: new Date().toISOString(),
                    scripts: [],
                    providers: ['self-hosted'],
                    keys: []
                };
                
                // Save user
                users.push(newUser);
                localStorage.setItem('users', JSON.stringify(users));
                
                // Auto-login
                currentUser = newUser;
                isAdmin = false;
                localStorage.setItem('userData', JSON.stringify(currentUser));
                localStorage.setItem('authToken', 'user-token-' + Date.now());
                
                document.getElementById('registerSuccess').innerHTML = '<i class="fas fa-check-circle"></i> Account created successfully!';
                document.getElementById('registerSuccess').style.display = 'flex';
                
                showNotification('Welcome to Arazure Hub!', 'success');
                
                setTimeout(() => {
                    showDashboard();
                }, 1500);
                
            } catch (error) {
                document.getElementById('registerError').innerHTML = '<i class="fas fa-exclamation-circle"></i> Registration failed. Please try again.';
                document.getElementById('registerError').style.display = 'flex';
            } finally {
                btn.innerHTML = originalText;
                btn.disabled = false;
            }
            
            return false;
        }
        
        function handleForgotPassword(event) {
            event.preventDefault();
            
            const email = document.getElementById('forgotEmail').value;
            
            // Show loading
            const btn = event.target.querySelector('button[type="submit"]');
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
            btn.disabled = true;
            
            // Clear previous messages
            document.getElementById('forgotError').style.display = 'none';
            document.getElementById('forgotSuccess').style.display = 'none';
            
            try {
                // Simulate API call
                setTimeout(() => {
                    // Don't allow password reset for admin account
                    if (email === SECRET_ADMIN_EMAIL) {
                        document.getElementById('forgotSuccess').innerHTML = '<i class="fas fa-check-circle"></i> Admin password reset requires system administrator access.';
                        document.getElementById('forgotSuccess').style.display = 'flex';
                    } else {
                        document.getElementById('forgotSuccess').innerHTML = '<i class="fas fa-check-circle"></i> Password reset instructions sent to ' + email;
                        document.getElementById('forgotSuccess').style.display = 'flex';
                    }
                    
                    // Clear form
                    event.target.reset();
                    
                    // Show login after delay
                    setTimeout(() => {
                        showLogin();
                    }, 3000);
                    
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                }, 1500);
                
            } catch (error) {
                document.getElementById('forgotError').innerHTML = '<i class="fas fa-exclamation-circle"></i> Network error. Please try again.';
                document.getElementById('forgotError').style.display = 'flex';
                btn.innerHTML = originalText;
                btn.disabled = false;
            }
            
            return false;
        }
        
        function handleLogout() {
            // Clear all stored data
            localStorage.removeItem('authToken');
            localStorage.removeItem('userData');
            localStorage.removeItem('rememberMe');
            
            // Reset state
            currentUser = null;
            isAdmin = false;
            
            // Show auth screen
            showAuth();
            showLogin();
            
            // Clear forms
            document.getElementById('loginFormElement').reset();
            
            showNotification('Logged out successfully', 'info');
        }
        
        // ==============================
        // UI Management Functions
        // ==============================
        function showAuth() {
            document.getElementById('authContainer').classList.add('active');
            document.getElementById('dashboardContainer').classList.remove('active');
        }
        
        function showDashboard() {
            document.getElementById('authContainer').classList.remove('active');
            document.getElementById('dashboardContainer').classList.add('active');
            loadUserData();
            loadDashboardData();
        }
        
        function showLogin() {
            document.getElementById('loginForm').style.display = 'block';
            document.getElementById('registerForm').style.display = 'none';
            document.getElementById('forgotPasswordForm').style.display = 'none';
            
            // Clear messages
            document.getElementById('loginError').style.display = 'none';
            document.getElementById('loginSuccess').style.display = 'none';
            document.getElementById('registerError').style.display = 'none';
            document.getElementById('registerSuccess').style.display = 'none';
            document.getElementById('forgotError').style.display = 'none';
            document.getElementById('forgotSuccess').style.display = 'none';
            
            // Pre-fill email if remembered
            const rememberedEmail = localStorage.getItem('userEmail');
            if (rememberedEmail && document.getElementById('loginEmail')) {
                document.getElementById('loginEmail').value = rememberedEmail;
                document.getElementById('rememberMe').checked = true;
            }
        }
        
        function showRegister() {
            document.getElementById('loginForm').style.display = 'none';
            document.getElementById('registerForm').style.display = 'block';
            document.getElementById('forgotPasswordForm').style.display = 'none';
            
            // Clear messages
            document.getElementById('loginError').style.display = 'none';
            document.getElementById('loginSuccess').style.display = 'none';
            document.getElementById('registerError').style.display = 'none';
            document.getElementById('registerSuccess').style.display = 'none';
            document.getElementById('forgotError').style.display = 'none';
            document.getElementById('forgotSuccess').style.display = 'none';
        }
        
        function showForgotPassword() {
            document.getElementById('loginForm').style.display = 'none';
            document.getElementById('registerForm').style.display = 'none';
            document.getElementById('forgotPasswordForm').style.display = 'block';
            
            // Clear messages
            document.getElementById('loginError').style.display = 'none';
            document.getElementById('loginSuccess').style.display = 'none';
            document.getElementById('registerError').style.display = 'none';
            document.getElementById('registerSuccess').style.display = 'none';
            document.getElementById('forgotError').style.display = 'none';
            document.getElementById('forgotSuccess').style.display = 'none';
        }
        
        function useAdminCredentials() {
            document.getElementById('loginEmail').value = SECRET_ADMIN_EMAIL;
            document.getElementById('loginPassword').value = SECRET_ADMIN_PASSWORD;
            document.getElementById('rememberMe').checked = true;
            
            showNotification('Admin credentials loaded', 'admin');
        }
        
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const toggleBtn = input.parentNode.querySelector('.toggle-password i');
            
            if (input.type === 'password') {
                input.type = 'text';
                toggleBtn.className = 'fas fa-eye-slash';
            } else {
                input.type = 'password';
                toggleBtn.className = 'fas fa-eye';
            }
        }
        
        // ==============================
        // Dashboard Functions
        // ==============================
        function loadUserData() {
            if (!currentUser) return;
            
            // Update user info
            document.getElementById('userName').textContent = currentUser.username;
            document.getElementById('userEmail').textContent = currentUser.email;
            document.getElementById('userRole').textContent = isAdmin ? 'Administrator' : 'Premium User';
            document.getElementById('topUsername').textContent = currentUser.username;
            
            // Set avatar
            const avatarLetter = currentUser.username.charAt(0).toUpperCase();
            document.getElementById('userAvatar').textContent = avatarLetter;
            document.getElementById('topAvatar').textContent = avatarLetter;
            
            // Add admin badge if admin
            if (isAdmin) {
                document.getElementById('userAvatar').classList.add('admin');
                document.getElementById('topAvatar').classList.add('admin');
                document.getElementById('topUserBadge').classList.add('admin');
                document.getElementById('userRole').innerHTML = 'Administrator <span class="admin-badge"><i class="fas fa-crown"></i> Admin</span>';
                
                // Show admin sections
                document.getElementById('adminSection').style.display = 'block';
                document.getElementById('adminWelcomePanel').style.display = 'block';
                document.getElementById('adminStatCard').style.display = 'block';
            }
            
            // Update page title
            document.getElementById('pageTitle').textContent = `Welcome, ${currentUser.username}`;
            document.getElementById('pageSubtitle').textContent = isAdmin ? 
                'System Administrator Dashboard' : 
                `Last login: ${new Date().toLocaleDateString()}`;
        }
        
        function loadDashboardData() {
            // Simulate loading data
            setTimeout(() => {
                // Update stats
                const userScripts = currentUser.scripts ? currentUser.scripts.length : 0;
                document.getElementById('totalScripts').textContent = userScripts;
                
                // Update total users for admin
                if (isAdmin) {
                    const users = JSON.parse(localStorage.getItem('users') || '[]');
                    document.getElementById('totalUsers').textContent = users.length + 1; // +1 for admin
                }
                
                // Update recent activity
                const activityDiv = document.getElementById('recentActivity');
                activityDiv.innerHTML = `
                    <div style="width: 100%;">
                        ${isAdmin ? `
                        <div style="padding: 20px; border-bottom: 1px solid var(--border);">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <div>
                                    <div style="font-weight: 600; color: var(--admin);">
                                        <i class="fas fa-user-shield"></i> Admin Login
                                    </div>
                                    <div style="color: var(--text-secondary); font-size: 14px; margin-top: 5px;">
                                        System administrator logged in
                                    </div>
                                </div>
                                <div style="color: var(--text-secondary); font-size: 12px;">
                                    Just now
                                </div>
                            </div>
                        </div>
                        ` : ''}
                        
                        <div style="padding: 20px; border-bottom: 1px solid var(--border);">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <div>
                                    <div style="font-weight: 600;">
                                        <i class="fas fa-sign-in-alt"></i> User Login
                                    </div>
                                    <div style="color: var(--text-secondary); font-size: 14px; margin-top: 5px;">
                                        ${currentUser.username} logged into the system
                                    </div>
                                </div>
                                <div style="color: var(--text-secondary); font-size: 12px;">
                                    ${new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                                </div>
                            </div>
                        </div>
                        
                        <div style="padding: 20px; text-align: center; color: var(--text-secondary);">
                            <i class="fas fa-history" style="font-size: 48px; margin-bottom: 20px; display: block;"></i>
                            <p>No recent script activity</p>
                            <button class="btn btn-secondary" onclick="switchTab('publish')" style="margin-top: 15px; width: auto; padding: 10px 20px;">
                                <i class="fas fa-upload"></i> Publish Your First Script
                            </button>
                        </div>
                    </div>
                `;
            }, 1000);
        }
        
        function refreshDashboard() {
            showNotification('Refreshing dashboard...', 'info');
            loadDashboardData();
            setTimeout(() => {
                showNotification('Dashboard updated', 'success');
            }, 1000);
        }
        
        // ==============================
        // Tab Navigation
        // ==============================
        function switchTab(tabId) {
            // Update navigation
            document.querySelectorAll('.nav-item').forEach(item => {
                item.classList.remove('active');
            });
            
            // Find and activate the clicked tab
            const navItems = document.querySelectorAll('.nav-item');
            navItems.forEach(item => {
                if (item.textContent.includes(tabId.charAt(0).toUpperCase() + tabId.slice(1).replace('-', ' ')) ||
                    item.getAttribute('onclick')?.includes(`'${tabId}'`)) {
                    item.classList.add('active');
                }
            });
            
            // Update content
            document.querySelectorAll('.content-area').forEach(area => {
                area.style.display = 'none';
            });
            
            const tabElement = document.getElementById(tabId);
            if (tabElement) {
                tabElement.style.display = 'block';
            }
            
            // Update page title
            const tabNames = {
                'overview': 'Dashboard Overview',
                'publish': 'Publish Script',
                'scripts': 'My Scripts',
                'profile': 'My Profile',
                'providers': 'My Providers',
                'keys': 'Key System',
                'settings': 'Settings',
                'analytics': 'Analytics',
                'reports': 'Reports',
                'webhooks': 'Webhooks',
                'billing': 'Billing',
                'admin-users': 'User Management',
                'admin-system': 'System Control',
                'admin-logs': 'Audit Logs'
            };
            
            document.getElementById('pageTitle').textContent = tabNames[tabId] || tabId;
            document.getElementById('pageSubtitle').textContent = isAdmin && tabId.includes('admin') ? 
                'Administrator Control Panel' : 'Manage your account and scripts';
        }
        
        // ==============================
        // Notification System
        // ==============================
        function showNotification(message, type = 'info') {
            const container = document.getElementById('notificationContainer');
            const notification = document.createElement('div');
            notification.className = `notification ${type}`;
            notification.innerHTML = `
                <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : type === 'admin' ? 'user-shield' : 'info-circle'}"></i>
                <span>${message}</span>
            `;
            
            container.appendChild(notification);
            
            setTimeout(() => {
                notification.classList.add('show');
            }, 10);
            
            setTimeout(() => {
                notification.classList.remove('show');
                setTimeout(() => {
                    notification.remove();
                }, 300);
            }, 3000);
        }
        
        // ==============================
        // Initialize on Load
        // ==============================
        document.addEventListener('DOMContentLoaded', init);
        
        // Auto-focus on login email if remembered
        window.addEventListener('load', () => {
            const rememberedEmail = localStorage.getItem('userEmail');
            if (rememberedEmail && document.getElementById('loginEmail')) {
                document.getElementById('loginEmail').value = rememberedEmail;
                document.getElementById('rememberMe').checked = true;
            }
        });
        
        // Add keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            // Ctrl + L for logout
            if (e.ctrlKey && e.key === 'l') {
                e.preventDefault();
                handleLogout();
            }
            
            // Ctrl + D for dashboard
            if (e.ctrlKey && e.key === 'd') {
                e.preventDefault();
                switchTab('overview');
            }
            
            // Ctrl + P for publish
            if (e.ctrlKey && e.key === 'p') {
                e.preventDefault();
                switchTab('publish');
            }
            
            // Escape to go back to overview
            if (e.key === 'Escape') {
                switchTab('overview');
            }
        });
    </script>
</body>
</html>

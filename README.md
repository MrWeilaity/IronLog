# IronLog (铁律) - 全方位运动健康管理平台

A comprehensive fitness and health management platform built with Spring Boot and Vue 3.

## Features

### 🏋️ Training Management
- **Training Log**: Record workouts with exercise type, duration, weight, reps, and sets
- **Exercise Library**: Browse and search exercises by name or muscle group
- **Training Plans**: Create and manage personalized training plans

### 🍎 Nutrition Management
- **Food Search**: Search from a comprehensive food database
- **Diet Logging**: Record meals with automatic nutrition calculation
- **Macro Tracking**: Track calories, protein, carbs, and fats

### 📊 Dashboard & Analytics
- **Personal Dashboard**: View daily stats, weekly activity, BMI metrics
- **Calendar Heatmap**: Visualize training consistency with status indicators
- **Statistics**: Analyze weight trends and exercise distribution
- **Leaderboards**: Compare with community on volume and streak rankings

### 👤 User Management
- **Profile Settings**: Update personal information, height, weight, goals
- **Admin Dashboard**: Monitor system health, user activity, and statistics

## Tech Stack

### Backend
- **Framework**: Spring Boot 3.1.5
- **Database**: MySQL 8.0
- **ORM**: Spring Data JPA
- **Java Version**: 17

### Frontend
- **Framework**: Vue 3
- **UI Library**: Element Plus
- **Build Tool**: Vite
- **Charts**: ECharts
- **HTTP Client**: Axios

## Prerequisites

- Java 17 or higher
- Maven 3.6+
- Node.js 16+ and npm
- MySQL 8.0+

## Installation

### 1. Database Setup

Create the database and run the SQL scripts:

```bash
# Method 1: Quick Start - Use the all-in-one initialization script (Recommended)
mysql -u root -p
CREATE DATABASE ironlog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
exit
mysql -u root -p ironlog < init_database.sql

# Method 2: Using full_db_script.sql
mysql -u root -p ironlog < full_db_script.sql

# If upgrading from older version, run migrations
mysql -u root -p ironlog < migration_001_add_simple_workout_fields.sql
mysql -u root -p ironlog < migration_002_add_bio_and_system_tables.sql
```

📖 For detailed database setup instructions, see [DATABASE_INIT_README.md](DATABASE_INIT_README.md)

### 2. Backend Setup

```bash
cd backend

# Update database connection in src/main/resources/application.properties
# spring.datasource.url=jdbc:mysql://localhost:3306/ironlog
# spring.datasource.username=your_username
# spring.datasource.password=your_password

# Build and run
mvn clean install
mvn spring-boot:run
```

The backend API will be available at `http://localhost:8080`

### 3. Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Development mode
npm run dev

# Production build
npm run build
```

The frontend will be available at `http://localhost:5173` (development) or can be served from `dist/` folder

## API Endpoints

### Authentication
- `POST /api/users/register` - Register new user
- `POST /api/users/login` - Login user
- `GET /api/users/{id}` - Get user profile
- `PUT /api/users/{id}` - Update user profile

### Training
- `GET /api/training/records` - Get training records
- `POST /api/training/records` - Add training record
- `DELETE /api/training/records/{id}` - Delete training record
- `GET /api/training/actions` - Search exercises

### Nutrition
- `GET /api/nutrition/foods` - Search foods
- `GET /api/nutrition/foods/{id}` - Get food details
- `POST /api/nutrition/foods` - Add custom food
- `GET /api/nutrition/diet-logs` - Get diet logs
- `POST /api/nutrition/diet-logs` - Add diet log

### Dashboard
- `GET /api/dashboard/stats/{userId}` - Get dashboard statistics
- `GET /api/dashboard/weekly-activity/{userId}` - Get weekly activity data
- `GET /api/dashboard/body-metrics/{userId}` - Get body metrics and BMI
- `GET /api/dashboard/recent-activities/{userId}` - Get recent activities

### Calendar
- `GET /api/calendar/heatmap/{userId}` - Get calendar heatmap data
- `GET /api/calendar/day-detail/{userId}` - Get day detail

### Statistics
- `GET /api/stats/leaderboard` - Get leaderboard rankings
- `GET /api/stats/user-stats/{userId}` - Get user statistics
- `GET /api/stats/weight-trend/{userId}` - Get weight trend
- `GET /api/stats/exercise-distribution/{userId}` - Get exercise distribution

### Admin
- `GET /api/admin/dashboard-stats` - Get admin dashboard statistics
- `GET /api/admin/recent-users` - Get recent registered users
- `GET /api/admin/system-health` - Get system health status

## Default Users

After running the database script, the following test users are available:

| Username | Password | Role  | Description |
|----------|----------|-------|-------------|
| admin    | 123456   | ADMIN | Administrator |
| zhangsan | 123456   | USER  | Test user 1 |
| lisi     | 123456   | USER  | Test user 2 |
| wangwu   | 123456   | USER  | Test user 3 |

## Project Structure

```
IronLog/
├── backend/
│   ├── src/main/java/com/ironlog/
│   │   ├── controller/      # REST API controllers
│   │   ├── service/         # Business logic
│   │   ├── repository/      # Data access layer
│   │   ├── entity/          # JPA entities
│   │   └── common/          # Common utilities
│   └── src/main/resources/
│       └── application.properties
├── frontend/
│   ├── src/
│   │   ├── views/          # Page components
│   │   ├── components/     # Reusable components
│   │   ├── router/         # Vue Router configuration
│   │   ├── utils/          # Utility functions
│   │   └── layout/         # Layout components
│   └── package.json
├── full_db_script.sql      # Complete database schema and sample data
├── migration_001_add_simple_workout_fields.sql  # Database migration
└── README.md
```

## Features Implemented

✅ User authentication and profile management  
✅ Training log with support for simple workouts and detailed exercises  
✅ Food search and nutrition tracking  
✅ Dashboard with statistics and charts  
✅ Calendar heatmap for training visualization  
✅ Community leaderboards (volume and streak)  
✅ Statistics page with weight trends and exercise distribution  
✅ Admin dashboard with system monitoring  
✅ Responsive UI with Element Plus components  

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is open source and available under the MIT License.

## Support

For issues and questions, please create an issue in the GitHub repository.

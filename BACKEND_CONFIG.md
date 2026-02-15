# ReyHowley Backend Configuration

## Application Information

- **APP_NAME**: ReyHowley
- **APP_ENV**: production
- **APP_DEBUG**: false
- **APP_INSTALL**: true
- **APP_URL**: <https://reyhowley.com>
- **APP_MODE**: live
- **APP_VERSION**: 3.6

## Database Configuration

The backend Laravel application uses the following database configuration:

```env
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=reyhowley
DB_USERNAME=reyhowley
DB_PASSWORD=MySuccess@6264
```

## Cache & Session

```env
BROADCAST_DRIVER=log
CACHE_DRIVER=database
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120
```

## Redis Configuration (Optional)

```env
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
```

## Mail Configuration

```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=
MAIL_PASSWORD=
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@your-domain.com
MAIL_FROM_NAME=ReyHowley
```

## AWS S3 Configuration (Optional)

```env
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
```

## Reverb/Pusher Configuration (Real-time features)

```env
REVERB_APP_ID=reyhowley
REVERB_APP_KEY=reyhowley
REVERB_APP_SECRET=reyhowley
REVERB_HOST=https://reyhowley.com
REVERB_PORT=6001
REVERB_SCHEME=https

PUSHER_APP_ID=reyhowley
PUSHER_APP_KEY=reyhowley
PUSHER_APP_SECRET=reyhowley
PUSHER_APP_CLUSTER=mt1
PUSHER_HOST=https://reyhowley.com
PUSHER_PORT=6001
PUSHER_SCHEME=https
```

## OpenAI Configuration (Optional)

```env
OPENAI_API_KEY=
OPENAI_ORGANIZATION=
```

## Software Activation (Open Source)

```env
SOFTWARE_ID=MzY3NzIxMTI=
BUYER_USERNAME=open_source
PURCHASE_CODE=open_source
SOFTWARE_VERSION=3.6
REACT_APP_KEY=45370351

The Flutter app has been updated with the following:

### Base URL

- **API Base URL**: `https://reyhowley.com`
- **Web Hosted URL**: `https://reyhowley.com`

### App Name Updates

- ✅ Android: `ReyHowley` (AndroidManifest.xml, strings.xml)
- ✅ iOS: `ReyHowley` (Info.plist)
- ✅ Dart Constants: `ReyHowley` (app_constants.dart)

### Package Identifiers

- Android: `com.sixamtech.sixam_mart_user`
- iOS: Configured in Xcode project

## Important Notes

### Backend Deployment

1. The backend should be deployed at `https://reyhowley.com`
2. Ensure all API endpoints are accessible from the Flutter app
3. Configure CORS settings on the backend to allow requests from the mobile app
4. Set up SSL certificate for HTTPS

### Database

- The database credentials are configured in the backend `.env` file
- Database name: `reyhowley`
- Ensure MySQL/MariaDB is properly configured in Coolify or your hosting environment

### Firebase Configuration

- Firebase services are configured in the app:
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`
- Ensure Firebase project is set up for both Android and iOS

### Social Login

- **Facebook App ID**: 380903914182154
- **Google Client ID**: 491987943015-agln6biv84krpnngdphj87jkko7r9lb8.apps.googleusercontent.com
- Ensure these are configured in your Firebase/Facebook console

### API Keys

- Google Maps API Key: `AIzaSyCaCSJ0BZItSyXqBv8vpD1N4WBffJeKhLQ`
  - Ensure this key is enabled for:
    - Maps SDK for Android
    - Maps SDK for iOS
    - Places API
    - Geocoding API
    - Directions API

## Testing Checklist

- [ ] Verify backend is accessible at <https://reyhowley.com>
- [ ] Test API endpoints from the Flutter app
- [ ] Verify database connection
- [ ] Test user registration and login
- [ ] Verify Firebase notifications
- [ ] Test social login (Google, Facebook, Apple)
- [ ] Verify Google Maps integration
- [ ] Test payment gateway integration

## Development Notes

- The app uses GetX for state management
- API client is configured in `lib/api/api_client.dart`
- All API constants are in `lib/util/app_constants.dart`
- The app supports multiple modules: Food, Grocery, Pharmacy, eCommerce, Parcel, Taxi/Rental

## Support
constants are in `lib/util/app_constants.dart`
- The app supports multiple modules: Food, Grocery, Pharmacy, eCommerce, Parcel, Taxi/Rental

## Support
For backend API documentation, refer to the Laravel backend project documentation.

`app\Http\Controllers\api\HomeController.php`

```php
<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function index(Request $request)
    {
        return response()->json([
            'status' => true,
            'data' => [                
                'app_name' => "Live App Title",
            ]
        ]);
    }
}
```

`routes\api.php`

```php
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

use App\Http\Controllers\api\HomeController;

Route::get('/home', [HomeController::class, 'index']);
```

```json
{
  "status": true,
  "data": {
    "app_name": "Live App Title"
  }
}
```
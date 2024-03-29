echo "==============================================="
echo "Project - DEPLOYMENT"
echo "==============================================="

echo "-----------------------------------------------"
echo "Project - Generate config file."
echo "-----------------------------------------------"
cp .env.example .env

echo "-----------------------------------------------"
echo "Project - Building steps and up all containers."
echo "-----------------------------------------------"
docker-compose up -d --build

echo "-----------------------------------------------"
echo "Project - Install/update composer dependecies."
echo "-----------------------------------------------"
docker-compose exec app composer install

echo "-----------------------------------------------"
echo "Project - Generating key."
echo "-----------------------------------------------"
docker-compose exec app php artisan key:generate

echo "-----------------------------------------------"
echo "Project - Artisan is migrating DB."
echo "-----------------------------------------------"
docker-compose exec app php artisan migrate

echo "-----------------------------------------------"
echo "Project - Fill data on DB."
echo "-----------------------------------------------"
docker-compose exec app php artisan db:seed

#echo "-----------------------------------------------"
#echo "Project - Build assets using mode development."
#echo "-----------------------------------------------"
# npm run dev

echo "-----------------------------------------------"
echo "Project - Show all containers."
echo "-----------------------------------------------"
docker ps

echo "-----------------------------------------------"
echo "Project - LIVE."
echo "-----------------------------------------------"

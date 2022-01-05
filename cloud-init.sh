#! /bin/sh
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2
cd /var/www/html/
sudo git clone https://github.com/Caradhras2021/NLPF2_Front.git
sudo mv NLPF2_Front/* .

sudo touch /1.txt

cd /
wget -qO- https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs
sudo git clone https://github.com/Caradhras2021/NLPF2_Back.git
cd NLPF2_Back/sedeloger-api/
sudo npm install --legacy-peer-deps
sudo npm install mysql --save

sudo touch /2.txt

sudo rm /NLPF2_Back/sedeloger-api/src/config/config.service.ts
echo "import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { HomeEntity } from 'src/home/home.entity';
import { UserEntity } from 'src/logs/logs.entity';
import { UsersEntity } from 'src/users/users.entity';

// eslint-disable-next-line @typescript-eslint/no-var-requires
require('dotenv').config();

class ConfigService {
  constructor(private env: { [k: string]: string | undefined }) {}

  private getValue(key: string, throwOnMissing = true): string {
    const value = this.env[key];
    if (!value && throwOnMissing) {
      throw new Error(`config error`);
    }

    return value;
  }

  public ensureValues(keys: string[]) {
    keys.forEach((k) => this.getValue(k, true));
    return this;
  }

  public getPort() {
    return this.getValue('PORT', true);
  }

  public isProduction() {
    const mode = this.getValue('MODE', false);
    return mode != 'DEV';
  }

  public getTypeOrmConfig(): TypeOrmModuleOptions {
    return {
      type: 'mysql',

      host: '${dns_lb}',
      port: 3306,
      username: 'repli',
      password: 'Caradhras2022',
      database: 'nlpf',

      entities: [HomeEntity, UserEntity, UsersEntity],
      synchronize: false,
    };
  }
}

const configService = new ConfigService(process.env).ensureValues([
  'POSTGRES_HOST',
  'POSTGRES_PORT',
  'POSTGRES_USER',
  'POSTGRES_PASSWORD',
  'POSTGRES_DATABASE',
]);

export { configService };" > /NLPF2_Back/sedeloger-api/src/config/config.service.ts

PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
sudo sed -i "s/const url = 'https:\/\/flexxnath.la.salo.pe\/';/const url = 'http:\/\/$PUBLIC_IP:3000\/';/g" /var/www/html/assets/js/estimate.js
sudo sed -i "s/const url = 'https:\/\/flexxnath.la.salo.pe\/';/const url = 'http:\/\/$PUBLIC_IP:3000\/';/g" /var/www/html/assets/js/logs.js
sudo sed -i "s/const url = 'https:\/\/flexxnath.la.salo.pe\/';/const url = 'http:\/\/$PUBLIC_IP:3000\/';/g" /var/www/html/assets/js/project.js
sudo sed -i "s/const url = 'https:\/\/flexxnath.la.salo.pe\/';/const url = 'http:\/\/$PUBLIC_IP:3000\/';/g" /var/www/html/assets/js/typeLogs.js
sudo sed -i "s/const url = 'https:\/\/flexxnath.la.salo.pe\/';/const url = 'http:\/\/$PUBLIC_IP:3000\/';/g" /var/www/html/assets/js/find.js
sudo sed -i "s/const url = 'https:\/\/flexxnath.la.salo.pe\/';/const url = 'http:\/\/$PUBLIC_IP:3000\/';/g" /var/www/html/assets/js/surfaceLogs.js
sudo sed -i "s/const url = 'https:\/\/flexxnath.la.salo.pe\/';/const url = 'http:\/\/$PUBLIC_IP:3000\/';/g" /var/www/html/assets/js/useLogs.js

sudo sed -i "s/Se déloger - Accueil/$PUBLIC_IP/g" /var/www/html/index.html

cd /NLPF2_Back/sedeloger-api
sudo npm start 
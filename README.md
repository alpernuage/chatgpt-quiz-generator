[![Symfony 7](https://img.shields.io/badge/Symfony-7.3-black.svg?style=flat-square&logo=symfony)](https://symfony.com/)
[![PHP 8.2](https://img.shields.io/badge/PHP-8.2-purple.svg?style=flat-square&logo=php)](https://www.php.net/)
[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)](https://react.dev/)
[![Doctrine ORM](https://img.shields.io/badge/Doctrine%20ORM-AA0000?style=flat-square&logo=doctrine&logoColor=white)](https://www.doctrine-project.org/projects/orm.html)
[![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=flat-square&logo=mariadb&logoColor=white)](https://mariadb.org/)
[![OpenAI API](https://img.shields.io/badge/OpenAI%20API-424650?style=flat-square&logo=openai&logoColor=white)](https://platform.openai.com/docs/overview)
[![Webpack Encore](https://img.shields.io/badge/Webpack%20Encore-8DD6F9?style=flat-square&logo=webpack&logoColor=black)](https://symfony.com/doc/current/frontend/encore/index.html)
[![Material-UI](https://img.shields.io/badge/Material--UI-007FFF?style=flat-square&logo=mui&logoColor=white)](https://mui.com/)
[![Symfony UX React](https://img.shields.io/badge/Symfony%20UX%20React-1A405D?style=flat-square&logo=symfony&logoColor=white)](https://symfony.com/bundles/ux-react/current/index.html)
[![Stimulus](https://img.shields.io/badge/Stimulus-48A096?style=flat-square&logo=hotwired&logoColor=white)](https://stimulus.hotwired.dev/)
[![PHPUnit](https://img.shields.io/badge/PHPUnit-8A1BE2?style=flat-square&logo=phpunit&logoColor=white)](https://phpunit.de/)
[![Composer](https://img.shields.io/badge/Composer-885630?style=flat-square&logo=composer&logoColor=white)](https://getcomposer.org/)
[![NPM](https://img.shields.io/badge/NPM-CB3837?style=flat-square&logo=npm&logoColor=white)](https://www.npmjs.com/)

#  Quiz Generator with Symfony, React & ChatGPT
Ce projet est une application web qui génère des quiz interactifs avec une interface utilisateur dynamique.  
L'API de ChatGPT (_OpenAI model gpt-3.5-turbo_ - _La dernière mise à jour des données: 01/09/2021_) est utilisé pour la génération intelligente du contenu des quiz avec 5 questions et 3 réponses par question.  
L'objectif est de permettre aux utilisateurs de créer facilement des quiz sur n'importe quel sujet, grâce à la puissance de l'IA.

## Prérequis

Assurez-vous d'avoir les éléments suivants installés sur votre système :

- PHP 8.2+
- Symfony CLI
- Composer
- Node.js (avec npm)
- Un serveur de base de données (MariaDB ou MySQL)
- Un compte [OpenAI](https://openai.com/index/openai-api/) avec une clé API active et des crédits/méthode de paiement configurés.

## Installation
- `git clone git@github.com:alpernuage/chatgpt-quiz-generator.git`
- `cd chatgpt-quiz-generator`
- `OPENAI_API_KEY=sk-proj-...` # [Votre clé API OpenAI](https://platform.openai.com/account/api-keys)

[//]: # (- `make install`)

- composer install
- npm install
- symfony console doctrine:database:create
- symfony console doctrine:migrations:migrate
- symfony serve -d
- npm run watch

## Visuelles
![Image](https://github.com/user-attachments/assets/5bbf85b1-5529-4711-bdba-059146d9c3b4)
![Image](https://github.com/user-attachments/assets/cd3bcc6e-214b-44f1-b1db-ddd0b52ae0be)
![Image](https://github.com/user-attachments/assets/704be1b9-b4a5-49a1-8628-e9382fbf65d3)

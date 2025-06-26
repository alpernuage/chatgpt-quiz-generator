<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class QuizController extends AbstractController
{
    #[Route('/quizzes', name: 'app_quizzes_add', methods: ['POST'])]
    public function add(Request $request): Response
    {
        if (!$request->isXmlHttpRequest()) {
            return $this->json([
                'error' => 'Method not allowed',
            ]);
        }

        $body = json_decode($request->getContent(), true);

        if(!isset($body['content'])) {
            return $this->json([
                'error' => 'Missing content',
            ]);
        }

        return $this->json([]);
    }
}

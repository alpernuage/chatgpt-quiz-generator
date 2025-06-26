<?php

namespace App\Controller;

use App\Service\QuizService;
use OpenAI\Client;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class QuizController extends AbstractController
{
    public function __construct(
        private readonly QuizService $quizService,
    )
    {
    }

    #[Route('/quizzes', name: 'app_quizzes_add', methods: ['POST'])]
    public function add(Client $client, Request $request): Response
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

        $content = "Rédige un quiz de 5 questions avec un titre et 3 réponses par questions portant sur le sujet '{$body['content']}' au format JSON.
        Les propriétés utilisées sont 'answer', 'answers' et 'question'.";

        $content = $client->chat()->create([
            'model' => 'gpt-3.5-turbo',
            'messages' => [
                [
                    'role' => 'user',
                    'content' => $content,
                ],
            ],
        ])['choices'][0]['message']['content'];

        $quizData = json_decode($content, true);

        $quiz = $this->quizService->add($quizData);

        return $this->json([
            'quiz' => [
                'id' => $quiz->getId()
            ]
        ]);
    }
}

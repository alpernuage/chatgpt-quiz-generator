import React from 'react';
import {Button, Container, MobileStepper} from "@mui/material";
import Question from "./Question";

export default function Quiz(props) {
    const quiz = JSON.parse(props.quiz);

    const [activeStep, setActiveStep] = React.useState(0);
    const [quizResult, setQuizResult] = React.useState([]);

    const handleSubmit = async (e) => {
        e.preventDefault();

        const formData = new FormData(e.target);
        quizResult.push({ questionId: quiz.questions[activeStep].id, answerId: parseInt(formData.get('answer')) });

        console.log(quizResult);

        if (!isLastQuestion()) {
            setActiveStep(prevState => prevState + 1);
            return;
        }
        // } else {
            const response = await fetch(`/quizzes/${quiz.id}`, {
                body: JSON.stringify({ quizResult: quizResult}),
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });

            const json = await response.json();

            window.location.href = `/quizzes/result/${json.quizResult.id}`;
        // }
    }

    const isLastQuestion = () => {
        return (activeStep + 1) === quiz.questions.length;
    }

    return (
        <Container maxWidth="sm">
            <MobileStepper
                activeStep={activeStep}
                backButton={<Button style={{ visibility: "hidden" }}>Back</Button>}
                nextButton={<Button style={{ visibility: "hidden" }}>Next</Button>}
                position="static"
                steps={quiz.questions.length}
                sx={{ flexGrow: 1 }}
                variant="dots"
            />
            <form onSubmit={handleSubmit}>
                <Question question={quiz.questions[activeStep]} />
                <div style={{ marginTop: 10, textAlign: "center" }}>
                    <Button type="submit" variant="contained">
                        {isLastQuestion() ? 'Terminer' : 'Suivant'}
                    </Button>
                </div>
            </form>
        </Container>
    );
}

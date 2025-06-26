import React from 'react';
import {Button, Card, Container, Grid, TextField, Typography} from "@mui/material";

export default function CreateQuiz() {
    const handleSubmit = async (e) => {
        e.preventDefault();

        const formData = new FormData(e.target);
        const content = formData.get('content');
        console.log(content);

        const response = await fetch('/quizzes', {
            method: 'POST',
            body: JSON.stringify({ content }),
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            },
        });

        const data = await response.json();
        console.log(data);
    }

    return (
        <Container maxWidth="sm">
            <Grid container direction="row" justifyContent="center" alignItems="center">
                <Grid item>
                    <Typography fontWeight="bold" component="h2" variant="h2" marginY={5}>Make My Quiz</Typography>
                </Grid>
                <Grid item>
                    <Card style={{ padding: 15 }} variant="outlined">
                        <form onSubmit={handleSubmit}>
                            <TextField fullWidth label="Générer un quiz"  name="content" />
                            <Button fullWidth style={{ marginTop: 20 }} type="submit" variant="contained">Générer</Button>
                        </form>
                    </Card>
                </Grid>
            </Grid>
        </Container>
    );
}

import * as fs from "fs";
import * as path from "path";
import { parse } from 'csv-parse';

type Question = {
    name: string;
    question: string;
    a: string;
    b: string;
    c: string;
    d: string;
    e: string;
    f: string;
    g: string;
    h: string;
    i: string;
    j: string;
    k: string;
};

type Question_Object = {
    question: string;
    id: string;
    answers: string[];
    correct: string[];
};

(async () => {
    const csvFilePath = path.resolve(__dirname, 'data/questions_multiple_choice.csv');

    const headers = ['name', 'question', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k'];

    const fileContent = fs.readFileSync(csvFilePath, { encoding: 'utf-8' });

    const parsedQuestions: Question_Object[] = [];

    await parse(fileContent, {
        delimiter: ',',
        columns: headers,
    }, (error, result: Question[]) => {
        if (error) {
            console.error(error);
        }

        const pushAnswer = (answer: string, answers: string[]) => {
            if (answer.length > 0) {
                answers.push(answer);
            }

            return answers;
        }

        result.forEach((question) => {
            const questionString = question.question;

            const spacePosition = questionString.indexOf(" ");
            const questionId = questionString.substring(0, spacePosition);
            const questionText = questionString.substring(spacePosition + 1, questionString.length - 1);

            let answers: string[] = [];

            answers = pushAnswer(question.a, answers);
            answers = pushAnswer(question.b, answers);
            answers = pushAnswer(question.c, answers);
            answers = pushAnswer(question.d, answers);
            answers = pushAnswer(question.e, answers);
            answers = pushAnswer(question.f, answers);
            answers = pushAnswer(question.g, answers);
            answers = pushAnswer(question.h, answers);
            answers = pushAnswer(question.i, answers);
            answers = pushAnswer(question.j, answers);
            answers = pushAnswer(question.k, answers);

            const questionObject: Question_Object = { id: questionId, question: questionText, answers, correct: [] }

            parsedQuestions.push(questionObject);
        })

        const answersPath = path.resolve(__dirname, 'data/questions_answers.txt');
        const answers = fs.readFileSync(answersPath, { encoding: 'utf-8' });
        const answersLines = answers.split("\n")

        const formattedAnswersLines: string[] = []

        // Remove all leading 0s on ids
        answersLines.forEach((line) => {
            line = line.replace("^0+", "");
            formattedAnswersLines.push(line);
        });

        const foundAnswersIds: string[] = [];

        formattedAnswersLines.forEach((line) => {
            if (line.match("^[0-9]{1,2}.[0-9]{1,2}.[0-9]{1,3}$")) {
                foundAnswersIds.push(line);
            }
        });

        var index = 0;
        parsedQuestions.forEach((question) => {
            const answerIndex = formattedAnswersLines.indexOf(question.id);

            var currentLineIndex = answerIndex + 1;

            while (formattedAnswersLines.length > currentLineIndex && formattedAnswersLines[currentLineIndex].length > 0) {
                const lineAnswer = formattedAnswersLines[currentLineIndex];
                if (lineAnswer.substring(1, 2) === "*") {
                    question.correct.push(lineAnswer.substring(0, 1))
                }
                currentLineIndex++;
            }

            parsedQuestions[index] = question;
            index++;
        });

        console.log(parsedQuestions);

        parsedQuestions.forEach((question) => {
            if (question.correct.length == 0) {

                console.warn(question.id + " has no correct answers!")
            }
        })

        foundAnswersIds.forEach((answerId) => {
            var foundQuestion = false;
            for (const question of parsedQuestions) {
                if (question.id == answerId) {
                    foundQuestion = true;
                    break;
                }
            }

            if (!foundQuestion) {
                console.warn(answerId + " has corresponding question!")
            }
        })

        const parsedAnswersFilename = path.resolve(__dirname, 'parsed/questions.json');
        fs.writeFileSync(parsedAnswersFilename, JSON.stringify(parsedQuestions, null, "\t"), { encoding: 'utf-8' });
    });
})();
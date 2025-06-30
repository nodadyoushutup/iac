# File: project/questions.py
import logging
import getpass

logger = logging.getLogger(__name__)

class Question:
    def __init__(self, key, prompt, default=None, action=None):
        self.key = key
        self.prompt = prompt
        self.default = default
        self.action = action
        self.answer = None

class Questionnaire:
    def __init__(self, questions):
        self.questions = questions

    def ask_all(self):
        index = 0
        total = len(self.questions)
        while index < total:
            q = self.questions[index]
            prompt_text = q.prompt
            if q.default is not None:
                prompt_text += f" [default: {q.default}]"
            prompt_text += " (Type '\\prev' to go back, '\\next' to skip) "
            # Use getpass for password prompts
            if "password" in q.prompt.lower():
                ans = getpass.getpass(prompt_text)
            else:
                ans = input(prompt_text)
            ans = ans.strip()
            if ans == r"\prev":
                index = max(0, index - 1)
                continue
            elif ans == r"\next":
                index = min(total - 1, index + 1)
                continue
            if ans == "" and q.default is not None:
                ans = q.default
            q.answer = ans
            index += 1

    def validate_all(self):
        for q in self.questions:
            if q.default is None and (q.answer is None or q.answer.strip() == ""):
                while True:
                    new_ans = input(f"No answer provided for '{q.prompt}'. Please enter a value: ").strip()
                    if new_ans:
                        q.answer = new_ans
                        break

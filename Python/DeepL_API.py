# Install DeepL API first -> pip install deepl

import deepl

auth_key = 'put your API key here'
translator = deepl.Translator(auth_key) 
result = translator.translate_text('probando programa', target_lang='EN-US') 
print(result.text)
result = translator.translate_text('testing program', target_lang='ES') 
print(result.text)

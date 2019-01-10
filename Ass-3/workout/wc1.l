%{
int charCount = 0;
int wordCount = 0;
int lineCount = 0;
%}
%%
[a-zA-Z]+	{wordCount++; charCount += strlen(yytext); }
[\n]		{charCount++; lineCount++; }
.		{charCount++; }
%%

main() {
  yylex();
  printf("Characters: %d Words: %d Lines %d\n",charCount, wordCount, lineCount);
}


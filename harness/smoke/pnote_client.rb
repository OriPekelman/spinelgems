require 'pnote_client'
require 'pnote_client/utils/string_util'
require 'pnote_client/documents/pnote'
require 'pnote_client/documents/pnote/chapter'
require 'pnote_client/documents/pnote/sub_chapter'
require 'pnote_client/documents/pnote/problem'

# Exercise STYLES constant
puts PnoteClient::STYLES[:chapter]
puts PnoteClient::STYLES[:exercise_question]
puts PnoteClient::STYLES[:practice_teacher_comment].length

# Build a Pnote document tree and exercise counting methods
pnote = PnoteClient::Documents::Pnote.new

chapter = PnoteClient::Documents::Pnote::Chapter.new(title: "Chapter 1")

sub1 = PnoteClient::Documents::Pnote::SubChapter.new(title: "Sub 1")
sub2 = PnoteClient::Documents::Pnote::SubChapter.new(title: "Sub 2")

# Create Problems and add them as exercises/practices
ex1 = PnoteClient::Documents::Pnote::Problem.new(question: "What is 2+2?", answer: "4")
ex2 = PnoteClient::Documents::Pnote::Problem.new(question: "What is 3+3?", answer: "6")
pr1 = PnoteClient::Documents::Pnote::Problem.new(question: "Practice Q1")

sub1.add_exercise(ex1)
sub1.add_exercise(ex2)
sub1.add_practice(pr1)

sub2.add_exercise(ex1)

chapter.add_sub_chapter(sub1)
chapter.add_sub_chapter(sub2)

pnote.add_chapter(chapter)

puts pnote.exercise_count
puts pnote.practice_count

# Exercise Problem's add_question_line and add_line (StringUtil mixin)
prob = PnoteClient::Documents::Pnote::Problem.new
prob.add_question_line("Line 1")
prob.add_question_line("Line 2")
puts prob.question

# Exercise choices parsing with circled numbers
prob2 = PnoteClient::Documents::Pnote::Problem.new
prob2.add_choice_line("①Apple ②Banana ③Cherry")
choices = prob2.choices
puts choices.length
puts choices.first

# Exercise answer extraction from answer_line
prob3 = PnoteClient::Documents::Pnote::Problem.new
prob3.add_answer_line("  [정답]  42  ")
puts prob3.answer

# Exercise add_explaination_line and add_tip_line
prob4 = PnoteClient::Documents::Pnote::Problem.new
prob4.add_explaination_line("Explanation part 1")
prob4.add_explaination_line("Explanation part 2")
puts prob4.explaination

prob4.add_tip_line("Tip A")
prob4.add_tip_line("Tip B")
puts prob4.tip

#include <stdlib.h>
#include <stdio.h>

/* Include the mruby header */
#include <mruby.h>
#include <mruby/array.h>

/* Package MRBC Bytecode */
#include <mruby/irep.h>
#include <concatenated_ruby_code.c>

int main(int argc, char *argv[])
{
  mrb_state *mrb = mrb_open();
  mrb_value ARGV = mrb_ary_new_capa(mrb, argc);
  int i;
  int return_value;

  for (i = 0; i < argc; i++) {
    mrb_ary_push(mrb, ARGV, mrb_str_new_cstr(mrb, argv[i]));
  }
  mrb_define_global_const(mrb, "ARGV", ARGV);

  /* Execute MRBC Bytecode from concatenated source */
  mrb_load_irep(mrb, concatenatedrb);

  mrb_close(mrb);
  return 0;
}

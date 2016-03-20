void requireFocus(GuimPlat item, GuimPlat form) {
  form.allCommand(new GuimEvent() {
    public void run(IGuim sender, GuimArg e) {
      GuimPlat p = (GuimPlat)sender;
      p.focused = false;
    }
  }
  );
  item.focused = true;
}
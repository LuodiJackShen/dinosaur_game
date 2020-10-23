class Tree {
  double start; //起始偏移量
  bool isSmall; //是否时小树
  bool isDouble; //是否创建两个相邻的树
  bool isAfter; //第二个树是否在主树的后面

  Tree(this.start, this.isSmall, this.isDouble, this.isAfter);
}

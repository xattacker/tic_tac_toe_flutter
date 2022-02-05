enum ConnectedDirection
{
  none,

  lt_rb, // 左上向右下
  rt_lb, // 右上向左下
  horizontal, // 橫向
  vertical // 直向
}

extension ConnectedDirectionExtension on ConnectedDirection
{
  ConnectedDirection next()
  {
    switch (this)
    {
      case ConnectedDirection.lt_rb:
        return ConnectedDirection.rt_lb;

      case ConnectedDirection.rt_lb:
        return ConnectedDirection.horizontal;

      case ConnectedDirection.horizontal:
        return ConnectedDirection.vertical;

      case ConnectedDirection.vertical:
        return ConnectedDirection.none;

      default:
        return ConnectedDirection.none;
    }
  }

  List<int> get offset
  {
    late var offset;

    switch (this)
    {
      case ConnectedDirection.lt_rb:
        offset = [1, 1];
        break;

      case ConnectedDirection.rt_lb:
        offset = [1, -1];
        break;

      case ConnectedDirection.horizontal:
        offset = [0, 1];
        break;

      case ConnectedDirection.vertical:
        offset = [1, 0];
        break;

      default:
        offset = [0, 0];
        break;
    }

    return offset;
  }
}

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:onionchatflutter/viewmodel/avatar_bloc.dart';

class AvatarWidget extends StatefulWidget {
  final double? radius;
  AvatarWidget({Key? key, this.radius}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AvatarWidgetState();
  }
}

class _AvatarWidgetState extends State<AvatarWidget> {
  @override
  void initState() {
    BlocProvider.of<AvatarBloc>(context).add(InitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvatarBloc, AvatarState>(builder: (ctx, state) {
      if (state is ReadyState) {
        return FutureBuilder<ImageProvider>(
          future: imgImageToUiImage(state.image).then((value) async => await getProviderFromImage(value)),
          builder: (ctx, r) => CircleAvatar(
            backgroundImage: r.data,
            radius: widget.radius,
          ),
        );
      }
      return Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    });
  }
}

Future<ui.Image> imgImageToUiImage(img.Image image) async {
  ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(
      image.getBytes(format: img.Format.rgba));
  ui.ImageDescriptor id = ui.ImageDescriptor.raw(buffer,
      height: image.height,
      width: image.width,
      pixelFormat: ui.PixelFormat.rgba8888);
  ui.Codec codec = await id.instantiateCodec(
      targetHeight: image.height, targetWidth: image.width);
  ui.FrameInfo fi = await codec.getNextFrame();
  ui.Image uiImage = fi.image;
  return uiImage;
}

Future<ImageProvider> getProviderFromImage(ui.Image image) async {
  final ByteData? bytedata =
      await image.toByteData(format: ui.ImageByteFormat.png);
  if (bytedata == null) {
    return Future.error("some error msg");
  }

  final Uint8List headedIntList = Uint8List.view(bytedata.buffer);
  return MemoryImage(headedIntList);
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Onboarding/profile_image_select_cubit.dart';

class ProfileUpload extends StatelessWidget {
  const ProfileUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      child: Material(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(120),
        child: InkWell(
          onTap: () async {
            await context.read<ProfileImageSelectCubit>().getImage();
          },
          child: Stack(children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 60,
              child:
                  BlocBuilder<ProfileImageSelectCubit, ProfileImageSelectState>(
                      buildWhen: (previous, current) {
                if (previous == current) {
                  return true;
                } else {
                  return true;
                }
              }, builder: (context, state) {
                if (state is imageUploaded) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: Image.file(
                      state.imagefile,
                      width: 120,
                      height: 120,
                      fit: BoxFit.fill,
                    ),
                  );
                } else {
                  return const Icon(
                    Icons.person_outline_rounded,
                    size: 120,
                    color: Colors.grey,
                  );
                }
              }),
            ),
            const Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.add_circle_rounded,
                color: Colors.green,
                size: 38.0,
              ),
            )
          ]),
        ),
      ),
    );
  }
}

use bevy::prelude::*;
use bevy_app_compute::prelude::*;

#[derive(TypePath)]
pub struct BlurShader;

impl ComputeShader for BlurShader {
    fn shader() -> ShaderRef {
        "shaders/blur.wgsl".into()
    }
}

#[derive(Debug, Copy, Clone)]
pub enum BlurWorkerFields {
    Image,
    ImageSize,
    BlurSize,
}
pub const BLUR_WORKGROUP_SIZE: u32 = 16;

#[derive(Resource)]
pub struct BlurComputeWorker;

impl ComputeWorker for BlurComputeWorker {
    type Fields = BlurWorkerFields;

    fn build(app: &mut App) -> AppComputeWorker<Self> {
        let worker = AppComputeWorkerBuilder::new(app)
            .add_staging(Self::Fields::Image, &[0.0f32])
            .add_storage(Self::Fields::ImageSize, &[1u32, 1u32])
            .add_storage(Self::Fields::BlurSize, &[1u32, 1u32])
            .add_pass::<BlurShader>(
                [1, 1, 1],
                &[
                    Self::Fields::Image,
                    Self::Fields::ImageSize,
                    Self::Fields::BlurSize,
                ],
            )
            .immediate()
            .build();

        worker
    }
}

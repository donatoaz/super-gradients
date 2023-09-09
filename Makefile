unit_tests:
	python -m unittest tests/deci_core_unit_test_suite_runner.py

integration_tests:
	python -m unittest tests/deci_core_integration_test_suite_runner.py

yolo_nas_integration_tests:
	python -m unittest tests/integration_tests/yolo_nas_integration_test.py

recipe_accuracy_tests:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_pose_dekr_w32_no_dc experiment_name=shortened_coco2017_pose_dekr_w32_ap_test epochs=1 batch_size=4 val_batch_size=8 training_hyperparams.lr_warmup_steps=0 training_hyperparams.average_best_models=False training_hyperparams.max_train_batches=1000 training_hyperparams.max_valid_batches=100 multi_gpu=DDP num_gpus=4
	python src/super_gradients/train_from_recipe.py --config-name=cifar10_resnet               experiment_name=shortened_cifar10_resnet_accuracy_test   epochs=100 training_hyperparams.average_best_models=False multi_gpu=DDP num_gpus=4
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolox               experiment_name=shortened_coco2017_yolox_n_map_test      epochs=10  architecture=yolox_n training_hyperparams.loss=yolox_fast_loss training_hyperparams.average_best_models=False multi_gpu=DDP num_gpus=4
	python src/super_gradients/train_from_recipe.py --config-name=cityscapes_regseg48          experiment_name=shortened_cityscapes_regseg48_iou_test   epochs=10 training_hyperparams.average_best_models=False multi_gpu=DDP num_gpus=4
	python src/super_gradients/examples/convert_recipe_example/convert_recipe_example.py --config-name=cifar10_conversion_params experiment_name=shortened_cifar10_resnet_accuracy_test
	coverage run --source=super_gradients -m unittest tests/deci_core_recipe_test_suite_runner.py


sweeper_test:
	python -m super_gradients.train_from_recipe -m --config-name=cifar10_resnet \
	  ckpt_root_dir=$$PWD \
	  experiment_name=sweep_cifar10 \
	  training_hyperparams.max_epochs=1 \
	  training_hyperparams.initial_lr=0.001,0.01

	# Make sure that experiment_dir includes $$expected_num_dir subdirectories. If not, fail
	subdir_count=$$(find "$$PWD/sweep_cifar10" -mindepth 1 -maxdepth 1 -type d | wc -l); \
	if [ "$$subdir_count" -ne 2 ]; then \
	  echo "Error: $$PWD/sweep_cifar10 should include 2 subdirectories but includes $$subdir_count."; \
	  exit 1; \
	fi


examples_to_docs:
	jupyter nbconvert --to markdown --output-dir="documentation/source/" --execute src/super_gradients/examples/model_export/models_export.ipynb


test:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s dataset_params=coco_pose_estimation_yolo_nas_dataset_params                  training_hyperparams.max_train_batches=8 training_hyperparams.max_valid_batches=8 training_hyperparams.max_epochs=1 dataset_params.train_dataset_params.data_dir=/home/bloodaxe/data/coco2017 dataset_params.val_dataset_params.data_dir=/home/bloodaxe/data/coco2017 num_gpus=4
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s dataset_params=coco_pose_estimation_yolo_nas_rescale_dataset_params          training_hyperparams.max_train_batches=8 training_hyperparams.max_valid_batches=8 training_hyperparams.max_epochs=1 dataset_params.train_dataset_params.data_dir=/home/bloodaxe/data/coco2017 dataset_params.val_dataset_params.data_dir=/home/bloodaxe/data/coco2017 num_gpus=4
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s dataset_params=coco_pose_estimation_yolo_nas_mosaic_dataset_params           training_hyperparams.max_train_batches=8 training_hyperparams.max_valid_batches=8 training_hyperparams.max_epochs=1 dataset_params.train_dataset_params.data_dir=/home/bloodaxe/data/coco2017 dataset_params.val_dataset_params.data_dir=/home/bloodaxe/data/coco2017 num_gpus=4
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s dataset_params=coco_pose_estimation_yolo_nas_mixup_dataset_params            training_hyperparams.max_train_batches=8 training_hyperparams.max_valid_batches=8 training_hyperparams.max_epochs=1 dataset_params.train_dataset_params.data_dir=/home/bloodaxe/data/coco2017 dataset_params.val_dataset_params.data_dir=/home/bloodaxe/data/coco2017 num_gpus=4
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s dataset_params=coco_pose_estimation_yolo_nas_mosaic_rescale_dataset_params   training_hyperparams.max_train_batches=8 training_hyperparams.max_valid_batches=8 training_hyperparams.max_epochs=1 dataset_params.train_dataset_params.data_dir=/home/bloodaxe/data/coco2017 dataset_params.val_dataset_params.data_dir=/home/bloodaxe/data/coco2017 num_gpus=4

coco2017_yolo_nas_pose_s:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s_weights_and_biases dataset_params=coco_pose_estimation_yolo_nas_dataset_params

coco2017_yolo_nas_pose_s_rescale:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s_weights_and_biases dataset_params=coco_pose_estimation_yolo_nas_rescale_dataset_params

coco2017_yolo_nas_pose_s_mosaic:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s_weights_and_biases dataset_params=coco_pose_estimation_yolo_nas_mosaic_dataset_params

coco2017_yolo_nas_pose_s_mosaic_bce_rescale_loss:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s_bce_rescale dataset_params=coco_pose_estimation_yolo_nas_mosaic_dataset_params

coco2017_yolo_nas_pose_s_mixup:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s_weights_and_biases dataset_params=coco_pose_estimation_yolo_nas_mixup_dataset_params

coco2017_yolo_nas_pose_s_ema_less_mosaic:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s_ema_less_mosaic

coco2017_yolo_nas_pose_s_less_mosaic:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s_less_mosaic

coco2017_yolo_nas_pose_s_ema_less_mosaic_higher_final_lr_fp32:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s_ema_less_mosaic_higher_final_lr_fp32

coco2017_yolo_nas_pose_s_ema_less_mosaic_lr_focal:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s_ema_less_mosaic_lr_focal

coco2017_yolo_nas_pose_shared_s_ema_less_mosaic_lr_focal_local:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_shared_s_ema_less_mosaic_lr_focal dataset_params.train_dataset_params.data_dir=/home/bloodaxe/data/coco2017 dataset_params.val_dataset_params.data_dir=/home/bloodaxe/data/coco2017 num_gpus=4

coco2017_yolo_nas_pose_s_ema_wider_head:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s_ema_wider_head

crowdpose_yolo_nas_pose_s:
	python src/super_gradients/train_from_recipe.py --config-name=crowdpose_yolo_nas_pose_s
	python src/super_gradients/train_from_recipe.py --config-name=crowdpose_yolo_nas_pose_s_new_assigner
	python src/super_gradients/train_from_recipe.py --config-name=crowdpose_yolo_nas_pose_s_bce
	python src/super_gradients/train_from_recipe.py --config-name=crowdpose_yolo_nas_pose_s_bce_rescale
	python src/super_gradients/train_from_recipe.py --config-name=crowdpose_yolo_nas_pose_s_bce_rescale_smooth_l1


coco2017_yolo_nas_pose_s_sgd_local:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s_sgd_local num_workers=16

coco2017_yolo_nas_pose_s_rescale_local:
	python src/super_gradients/train_from_recipe.py --config-name=coco2017_yolo_nas_pose_s_rescale_local num_workers=16 num_gpus=4

animalpose_gridsearch:
	CUDA_VISIBLE_DEVICES=0 python src/super_gradients/train_from_recipe.py -m --config-name=animalpose_yolo_nas_pose_s_grid_search arch_params.heads.YoloNASPoseNDFLHeads.compensate_grid_cell_offset=False  arch_params.heads.YoloNASPoseNDFLHeads.pose_offset_multiplier=1.0 dataset_params=animalpose_pose_estimation_yolo_nas_pose_dataset_params,animalpose_pose_estimation_yolo_nas_mosaic_pose_dataset_params &
	CUDA_VISIBLE_DEVICES=1 python src/super_gradients/train_from_recipe.py -m --config-name=animalpose_yolo_nas_pose_s_grid_search arch_params.heads.YoloNASPoseNDFLHeads.compensate_grid_cell_offset=False   arch_params.heads.YoloNASPoseNDFLHeads.pose_offset_multiplier=1.0 dataset_params=animalpose_pose_estimation_yolo_nas_pose_dataset_params,animalpose_pose_estimation_yolo_nas_mosaic_pose_dataset_params &
	CUDA_VISIBLE_DEVICES=2 python src/super_gradients/train_from_recipe.py -m --config-name=animalpose_yolo_nas_pose_s_grid_search arch_params.heads.YoloNASPoseNDFLHeads.compensate_grid_cell_offset=True   arch_params.heads.YoloNASPoseNDFLHeads.pose_offset_multiplier=1.0 dataset_params=animalpose_pose_estimation_yolo_nas_pose_dataset_params,animalpose_pose_estimation_yolo_nas_mosaic_pose_dataset_params &
	CUDA_VISIBLE_DEVICES=3 python src/super_gradients/train_from_recipe.py -m --config-name=animalpose_yolo_nas_pose_s_grid_search arch_params.heads.YoloNASPoseNDFLHeads.compensate_grid_cell_offset=True    arch_params.heads.YoloNASPoseNDFLHeads.pose_offset_multiplier=1.0 dataset_params=animalpose_pose_estimation_yolo_nas_pose_dataset_params,animalpose_pose_estimation_yolo_nas_mosaic_pose_dataset_params &

	CUDA_VISIBLE_DEVICES=4 python src/super_gradients/train_from_recipe.py -m --config-name=animalpose_yolo_nas_pose_s_grid_search arch_params.heads.YoloNASPoseNDFLHeads.compensate_grid_cell_offset=False  arch_params.heads.YoloNASPoseNDFLHeads.pose_offset_multiplier=2.0 dataset_params=animalpose_pose_estimation_yolo_nas_pose_dataset_params,animalpose_pose_estimation_yolo_nas_mosaic_pose_dataset_params &
	CUDA_VISIBLE_DEVICES=5 python src/super_gradients/train_from_recipe.py -m --config-name=animalpose_yolo_nas_pose_s_grid_search arch_params.heads.YoloNASPoseNDFLHeads.compensate_grid_cell_offset=False   arch_params.heads.YoloNASPoseNDFLHeads.pose_offset_multiplier=2.0 dataset_params=animalpose_pose_estimation_yolo_nas_pose_dataset_params,animalpose_pose_estimation_yolo_nas_mosaic_pose_dataset_params &
	CUDA_VISIBLE_DEVICES=6 python src/super_gradients/train_from_recipe.py -m --config-name=animalpose_yolo_nas_pose_s_grid_search arch_params.heads.YoloNASPoseNDFLHeads.compensate_grid_cell_offset=True   arch_params.heads.YoloNASPoseNDFLHeads.pose_offset_multiplier=2.0 dataset_params=animalpose_pose_estimation_yolo_nas_pose_dataset_params,animalpose_pose_estimation_yolo_nas_mosaic_pose_dataset_params &
	CUDA_VISIBLE_DEVICES=7 python src/super_gradients/train_from_recipe.py -m --config-name=animalpose_yolo_nas_pose_s_grid_search arch_params.heads.YoloNASPoseNDFLHeads.compensate_grid_cell_offset=True    arch_params.heads.YoloNASPoseNDFLHeads.pose_offset_multiplier=2.0 dataset_params=animalpose_pose_estimation_yolo_nas_pose_dataset_params,animalpose_pose_estimation_yolo_nas_mosaic_pose_dataset_params &

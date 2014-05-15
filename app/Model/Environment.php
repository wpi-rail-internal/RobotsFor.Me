<?php
/**
 * Environments Model
 *
 * Environments are linked to a rosbridge and MJPEG server. Each has a unique name.
 *
 * @author		Russell Toris - rctoris@wpi.edu
 * @copyright	2014 Worcester Polytechnic Institute
 * @link		https://github.com/WPI-RAIL/rms
 * @since		RMS v 2.0.0
 * @version		2.0.0
 * @package		app.Model
 */
class Environment extends AppModel {

	/**
	 * The validation criteria for the model.
	 *
	 * @var array
	 */
	public $validate = array(
		'id' => array(
			'notEmpty' => array(
				'rule' => 'notEmpty',
				'message' => 'Please enter a valid ID.',
				'required' => 'update'
			),
			'gt' => array(
				'rule' => array('comparison', '>', 0),
				'message' => 'IDs must be greater than 0.',
				'required' => 'update'
			),
			'isUnique' => array(
				'rule' => 'isUnique',
				'message' => 'This user ID already exists.',
				'required' => 'update'
			)
		),
		'name' => array(
			'notEmpty' => array(
				'rule' => 'notEmpty',
				'message' => 'Please enter a valid name.',
				'required' => true
			),
			'maxLength' => array(
				'rule' => array('maxLength', 255),
				'message' => 'Names cannot be longer than 255 characters.',
				'required' => true
			),
			'isUnique' => array(
				'rule' => 'isUnique',
				'message' => 'This namee already exists.',
				'required' => true
			)
		),
		'rosbridge_id' => array(
			'gt' => array(
				'rule' => array('comparison', '>', 0),
				'message' => 'rosbridge IDs must be greater than 0.',
				'allowEmpty' => true
			)
		),
		'mjpeg_id' => array(
			'gt' => array(
				'rule' => array('comparison', '>', 0),
				'message' => 'MJPEG IDs must be greater than 0.',
				'allowEmpty' => true
			)
		),
		'created' => array(
			'notEmpty' => array(
				'rule' => 'notEmpty',
				'message' => 'Please enter a valid creation time.',
				'required' => 'create'
			)
		),
		'modified' => array(
			'notEmpty' => array(
				'rule' => 'notEmpty',
				'message' => 'Please enter a valid modification time.',
				'required' => true
			)
		)
	);

	/**
	 * All environments have a rosbridge and MJPEG server.
	 *
	 * @var string
	 */
	public $belongsTo = array(
		'Rosbridge' => array('className' => 'Rosbridge'),
		'Mjpeg' => array('className' => 'Mjpeg')
	);
}
<?php
/**
 * Admin Edit MJPEG Server View
 *
 * The edit pages view allows an admin to edit an existing MJPEG server in the database.
 *
 * @author		Russell Toris - rctoris@wpi.edu
 * @copyright	2014 Worcester Polytechnic Institute
 * @link		https://github.com/WPI-RAIL/rms
 * @since		RMS v 2.0.0
 * @version		2.0.7
 * @package		app.View.Mjpegs
 */
?>

<header class="special container">
	<span class="icon fa-pencil"></span>
	<h2>Edit MJPEG Server</h2>
</header>

<?php echo $this->element('mjpeg_form', array('edit' => true)); ?>
